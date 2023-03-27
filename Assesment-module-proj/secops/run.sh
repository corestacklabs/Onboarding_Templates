#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "Project Owner"
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
read -p "Please enter the project id: " proj_id
read -p "Please enter the service account email: " svcacc
read -p "Do you need to retrive vunrelabilities and threat from GCP console? specify yes or no:" secops
if [ "${secops}" == "No" ] || [ "${secops}" == "no" ] ; then
cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
EOF
elif [ "${secops}" == "Yes" ] || [ "${secops}" == "yes" ] ; then
cat <<EOF > ./vars.tfvars
project_id = "$proj_id"
service_account_email = "$svcacc"
permissionsec = "Yes"
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi
fi