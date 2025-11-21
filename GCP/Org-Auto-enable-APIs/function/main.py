import os
import json
import logging
from google.cloud import firestore
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
import google.auth

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Environment variables
ORG_ID = os.environ["ORG_ID"]
STATE_COLLECTION = os.environ.get("STATE_COLLECTION", "org-inventory")
STATE_DOC = os.environ.get("STATE_DOC", "projects-seen")
FIRESTORE_DB = os.environ.get("FIRESTORE_DB", "(default)")

# APIs to enable for new projects
TARGET_APIS = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "recommender.googleapis.com",
    "billingbudgets.googleapis.com",
    "serviceusage.googleapis.com",
]

# Cache for API clients
_crm_client = None
_serviceusage_client = None


def _get_crm_client():
    """Get or create Cloud Resource Manager client."""
    global _crm_client
    if _crm_client is None:
        credentials, project = google.auth.default()
        _crm_client = build(
            "cloudresourcemanager",
            "v1",
            credentials=credentials,
            cache_discovery=False
        )
    return _crm_client


def _get_serviceusage_client():
    """Get or create Service Usage client."""
    global _serviceusage_client
    if _serviceusage_client is None:
        credentials, project = google.auth.default()
        _serviceusage_client = build(
            "serviceusage",
            "v1",
            credentials=credentials,
            cache_discovery=False
        )
    return _serviceusage_client


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


def _enable_api(project_id: str, api: str):
    """Enable an API for a project."""
    svc = _get_serviceusage_client()
    name = f"projects/{project_id}/services/{api}"
    
    try:
        svc.services().enable(name=name, body={}).execute()
        logger.info(f"Enabled {api} for project {project_id}")
        return {"project": project_id, "api": api, "status": "REQUESTED"}
    except HttpError as e:
        error_msg = f"HTTP {e.resp.status}: {e.content.decode() if e.content else str(e)}"
        logger.warning(f"Failed to enable {api} for {project_id}: {error_msg}")
        return {"project": project_id, "api": api, "error": error_msg}


def entrypoint(event, context=None):
    """Main entry point for the Cloud Function."""
    try:
        logger.info(f"Starting function execution. Using Firestore database: {FIRESTORE_DB}")
        
        # Initialize Firestore client
        db = firestore.Client(database=FIRESTORE_DB)
        logger.info("Firestore client initialized successfully")
        
        # Get state document
        doc_ref = db.collection(STATE_COLLECTION).document(STATE_DOC)
        snap = doc_ref.get()
        logger.info(f"Retrieved state document. Exists: {snap.exists}")
        
        # Get all projects in org
        current_projects = _get_all_projects_in_org()
        logger.info(f"Found {len(current_projects)} active projects in org")
        
        # Get previously seen projects
        seen_projects = set(snap.to_dict().get("project_ids", [])) if snap.exists else set()
        logger.info(f"Found {len(seen_projects)} previously seen projects")
        
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
        
        # Update state document with current projects
        doc_ref.set({"project_ids": sorted(list(current_projects))})
        logger.info("Updated state document with current projects")
        
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
