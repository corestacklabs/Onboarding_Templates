#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "- Organization level Security Admin Role"
echo "- Service Usage Admin"
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT
if [ -f vars.tfvars ]; then
  echo vars.tfvars exists.
  terraform init
  terraform apply -var-file="vars.tfvars" -auto-approve
  echo "Approved"
else
if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
     # exiting with return code 0
   echo 'Exiting..'
   exit 0 
elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
read -p "Please enter the Organisation id: " org_id
read -p "Please enter the service account email: " svcacc
read -p "Assign predefined role?(roles/viewer) specify yes or no: " role
  if [ "${role}" == "No" ] || [ "${role}" == "no" ] ; then
  read -p "Do you need to retrive vunrelabilities and threat from GCP console? specify yes or no:" secops
  read -p "Creating custom role, provide the name: " roleid
  if [ "${secops}" == "No" ] || [ "${secops}" == "no" ] ; then
  cat <<EOF > ./vars.tfvars
org_id = "$org_id"
service_account_email = "$svcacc"
role_id = "$roleid"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
EOF
  elif [ "${secops}" == "yes" ] || [ "${secops}" == "Yes" ]; then
 cat <<EOF > ./vars.tfvars
org_id = "$org_id"
service_account_email = "$svcacc"
role_id = "$roleid"
permissionsec = "yes"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
EOF
  elif [ "${role}" == "Yes" ]||[ "${role}" == "yes" ] ; then
  echo "granting predefined roles:"
  cat <<EOF > ./vars.tfvars
org_id = "$org_id"
service_account_email = "$svcacc"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
EOF
fi
fi
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi
fi