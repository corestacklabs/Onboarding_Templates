import os
import json
import logging
from datetime import datetime
from google.cloud import storage
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import google.auth

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Environment variables
ORG_ID = os.environ["ORG_ID"]
STATE_BUCKET = os.environ["STATE_BUCKET"]
STATE_FILE = os.environ.get("STATE_FILE", "org-inventory/projects-seen.json")

# APIs to enable for new projects
TARGET_APIS = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "recommender.googleapis.com",
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
]

# Cache for credentials only (not clients)
_credentials = None


def _get_credentials():
    """Get default credentials."""
    global _credentials
    if _credentials is None:
        _credentials, _ = google.auth.default()
    return _credentials


def _get_crm_client():
    """Create a fresh Cloud Resource Manager client."""
    credentials = _get_credentials()
    return build(
        "cloudresourcemanager",
        "v1",
        credentials=credentials,
        cache_discovery=False
    )


def _get_serviceusage_client():
    """Create a fresh Service Usage client."""
    credentials = _get_credentials()
    return build(
        "serviceusage",
        "v1",
        credentials=credentials,
        cache_discovery=False
    )


def _get_all_projects_in_org():
    """Get all active projects in the organization."""
    crm = _get_crm_client()
    request = crm.projects().list()
    projects = []
    
    while request is not None:
        try:
            resp = request.execute()
            for p in resp.get("projects", []):
                if p.get("lifecycleState") == "ACTIVE":
                    parent = p.get("parent", {})
                    if parent.get("type") == "organization" and parent.get("id") == ORG_ID:
                        projects.append(p["projectId"])
            request = crm.projects().list_next(previous_request=request, previous_response=resp)
        except HttpError as e:
            logger.error(f"Error listing projects: {e}")
            raise
    
    return set(projects)


def _enable_api(project_id: str, api: str, max_retries=2):
    """Enable an API for a project with retry logic."""
    name = f"projects/{project_id}/services/{api}"
    
    for attempt in range(max_retries + 1):
        try:
            # Create a fresh client for each attempt to avoid connection issues
            svc = _get_serviceusage_client()
            svc.services().enable(name=name, body={}).execute()
            logger.info(f"Enabled {api} for project {project_id}")
            return {"project": project_id, "api": api, "status": "REQUESTED"}
        except HttpError as e:
            error_content = e.content.decode() if e.content else ""
            error_status = e.resp.status if hasattr(e, 'resp') else None
            
            # Check if this is a billing-related error (don't retry)
            is_billing_error = (
                "billing" in error_content.lower() or
                "BILLING_NOT_OPEN" in error_content or
                "FAILED_PRECONDITION" in error_content
            )
            
            # Check if this is a permission/access error (don't retry)
            is_permission_error = (
                error_status == 403 or
                "PERMISSION_DENIED" in error_content or
                "access denied" in error_content.lower()
            )
            
            # Don't retry for billing or permission errors
            if is_billing_error or is_permission_error:
                status = "SKIPPED_BILLING_REQUIRED" if is_billing_error else "SKIPPED_PERMISSION_DENIED"
                logger.info(f"Skipped {api} for {project_id}: {'Billing not enabled' if is_billing_error else 'Permission denied'}")
                return {
                    "project": project_id,
                    "api": api,
                    "status": status,
                    "error": f"HTTP {error_status}: {error_content[:200]}" if error_content else str(e)
                }
            
            # For other errors, retry if attempts remain
            if attempt < max_retries:
                logger.warning(f"Attempt {attempt + 1} failed for {api} in {project_id}, retrying...")
                continue
            else:
                error_msg = f"HTTP {error_status}: {error_content[:200]}" if error_content else str(e)
                logger.warning(f"Failed to enable {api} for {project_id} after {max_retries + 1} attempts: {error_msg}")
                return {"project": project_id, "api": api, "status": "FAILED", "error": error_msg}
        except (AttributeError, ValueError) as e:
            # Connection/parsing errors - retry
            if attempt < max_retries:
                logger.warning(f"Attempt {attempt + 1} failed for {api} in {project_id} (connection error), retrying...")
                continue
            else:
                error_msg = str(e)
                logger.warning(f"Failed to enable {api} for {project_id} after {max_retries + 1} attempts: {error_msg}")
                return {"project": project_id, "api": api, "status": "FAILED", "error": error_msg}
        except Exception as e:
            error_msg = str(e)
            logger.warning(f"Unexpected error enabling {api} for {project_id}: {error_msg}")
            return {"project": project_id, "api": api, "status": "FAILED", "error": error_msg}


def _load_state_from_storage():
    """Load state from Cloud Storage."""
    try:
        client = storage.Client()
        bucket = client.bucket(STATE_BUCKET)
        blob = bucket.blob(STATE_FILE)
        
        if blob.exists():
            content = blob.download_as_text()
            state_data = json.loads(content)
            logger.info(f"Loaded state from {STATE_BUCKET}/{STATE_FILE}")
            return set(state_data.get("project_ids", []))
        else:
            logger.info(f"State file {STATE_BUCKET}/{STATE_FILE} does not exist, starting fresh")
            return set()
    except Exception as e:
        logger.warning(f"Failed to load state from storage: {str(e)}, starting fresh")
        return set()


def _save_state_to_storage(project_ids):
    """Save state to Cloud Storage."""
    try:
        client = storage.Client()
        bucket = client.bucket(STATE_BUCKET)
        blob = bucket.blob(STATE_FILE)
        
        project_list = sorted(list(project_ids))
        state_data = {
            "project_ids": project_list,
            "last_updated": datetime.utcnow().isoformat() + "Z",
            "total_projects": len(project_list)
        }
        
        blob.upload_from_string(
            json.dumps(state_data, indent=2),
            content_type="application/json"
        )
        logger.info(f"Successfully wrote {len(project_list)} projects to {STATE_BUCKET}/{STATE_FILE}")
        
        # Verify the write
        if blob.exists():
            verify_content = blob.download_as_text()
            verify_data = json.loads(verify_content)
            logger.info(f"Verified: State file exists with {len(verify_data.get('project_ids', []))} projects")
        else:
            logger.warning("Warning: State file write verification failed")
    except Exception as e:
        logger.error(f"Failed to write state to storage: {str(e)}", exc_info=True)
        raise


def entrypoint(event, context=None):
    """Main entry point for the Cloud Function."""
    try:
        logger.info(f"Starting function execution. Using state bucket: {STATE_BUCKET}")
        logger.info(f"State file: {STATE_FILE}")
        
        # Load previously seen projects from Cloud Storage
        seen_projects = _load_state_from_storage()
        logger.info(f"Found {len(seen_projects)} previously seen projects")
        
        # Get all projects in org
        current_projects = _get_all_projects_in_org()
        logger.info(f"Found {len(current_projects)} active projects in org")
        
        # Find new projects
        new_projects = sorted(list(current_projects - seen_projects))
        logger.info(f"Found {len(new_projects)} new projects: {new_projects}")
        
        # Enable APIs for new projects
        results = []
        for pid in new_projects:
            logger.info(f"Processing new project: {pid}")
            for api in TARGET_APIS:
                result = _enable_api(pid, api)
                results.append(result)
        
        # Save updated state to Cloud Storage
        _save_state_to_storage(current_projects)
        
        # Prepare response
        response = {
            "examined": len(current_projects),
            "new_projects": new_projects,
            "enabled_apis": TARGET_APIS,
            "results_sample": results[:30],
            "total_results": len(results)
        }
        
        logger.info(f"Function execution completed successfully. Processed {len(new_projects)} new projects.")
        return json.dumps(response, indent=2)
        
    except Exception as e:
        logger.error(f"Error in entrypoint: {str(e)}", exc_info=True)
        return json.dumps({
            "error": str(e),
            "type": type(e).__name__
        }, indent=2)
