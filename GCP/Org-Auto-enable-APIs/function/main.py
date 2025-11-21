import os, json
from google.cloud import firestore
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

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

def _get_all_projects_in_org():
    crm = build("cloudresourcemanager", "v1")
    request = crm.projects().list()
    projects = []
    while request is not None:
        resp = request.execute()
        for p in resp.get("projects", []):
            if p.get("lifecycleState") == "ACTIVE":
                parent = p.get("parent", {})
                if parent.get("type") == "organization" and parent.get("id") == ORG_ID:
                    projects.append(p["projectId"])
        request = crm.projects().list_next(previous_request=request, previous_response=resp)
    return set(projects)

def _enable_api(project_id: str, api: str):
    svc = build("serviceusage", "v1")
    name = f"projects/{project_id}/services/{api}"
    try:
        svc.services().enable(name=name, body={}).execute()
        return {"project": project_id, "api": api, "status": "REQUESTED"}
    except HttpError as e:
        return {"project": project_id, "api": api, "error": str(e)}

def entrypoint(event, context=None):
    db = firestore.Client(database=FIRESTORE_DB)
    doc_ref = db.collection(STATE_COLLECTION).document(STATE_DOC)
    snap = doc_ref.get()

    current_projects = _get_all_projects_in_org()
    seen_projects = set(snap.to_dict().get("project_ids", [])) if snap.exists else set()

    new_projects = sorted(list(current_projects - seen_projects))

    results = []
    for pid in new_projects:
        for api in TARGET_APIS:
            results.append(_enable_api(pid, api))

    # Update baseline so next run only handles truly new projects
    doc_ref.set({"project_ids": sorted(list(current_projects))})

    return json.dumps({
        "examined": len(current_projects),
        "new_projects": new_projects,
        "enabled_apis": TARGET_APIS,
        "results_sample": results[:30]
    })
