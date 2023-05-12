#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "- Project Owner"
if [ -f vars.tfvars ]; then
  echo vars.tfvars exists.
  terraform init
  terraform apply -var-file="vars.tfvars" -auto-approve
  echo "Approved"
else
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT
  if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
    echo 'Exiting..'
    exit 0 
  elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
    read -p "Please enter the project id: " proj_id
    read -p "Please enter the service account email: " svcacc
    echo "Assign predefined role?"
    echo "- roles/viewer or roles/editor"
    echo "- roles/pubsub.admin"
    echo "- roles/securitycenter.adminEditor"
    echo "- roles/monitoring.editor"
    echo "- roles/logging.configWriter"
    echo "- roles/compute.admin"
    read -p "Please specify yes or no: " role
    if [ "${role}" == "No" ] || [ "${role}" == "no" ] ; then
      read -p "Do you want to use the GCP Security Command Center? specify yes or no:" secops
      read -p "Creating custom role, provide the name: " roleid
      if [ "${secops}" == "No" ] || [ "${secops}" == "no" ] ; then
        cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
role_id = "$roleid"
EOF
      elif [ "${secops}" == "Yes" ] || [ "${secops}" == "yes" ] ; then
        cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
role_id = "$roleid"
permissionsec = "yes"
EOF
      fi
  elif [ "${role}" == "Yes" ]||[ "${role}" == "yes" ] ; then
        read -p "To assign a editor role . Specify yes or no": edit
        if [ "${edit}" == "yes" ] || [ "${edit}" == "Yes"]; then
        echo "granting predefined roles:(roles/editor, roles/pubsub.admin, roles/securitycenter.adminEditor, roles/monitoring.editor, roles/logging.configWriter, roles/compute.admin)"
  cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
assign_role_viewer = null
EOF
       elif [ "${edit}" == "no" ] || [ "${edit}" == "No"]; then
        echo "granting predefined roles:(roles/viewer, roles/pubsub.admin, roles/securitycenter.adminEditor, roles/monitoring.editor, roles/logging.configWriter, roles/compute.admin)"
  cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
EOF
  fi
  terraform init
  terraform apply -var-file="vars.tfvars" -auto-approve
  echo "Approved"
  fi
fi


