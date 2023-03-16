#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "Project Owner"
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT
if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
     # exiting with return code 0
   echo 'Exiting..'
   exit 0 
elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
read -p "Please enter the project id: " proj_id
read -p "Please enter the service account email: " svcacc
read -p "Assign predefined role?(roles/viewer) specify yes or no: " role
  if [ "${role}" == "No" ] || [ "${role}" == "no" ] ; then
  read -p "Creating custom role, provide the name: " roleid
  cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
role_id = "$roleid"
EOF
  elif [ "${role}" == "Yes" ]||[ "${role}" == "yes" ] ; then
  echo "granting predefined roles:(roles/viewer)"
  cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
EOF
fi
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi