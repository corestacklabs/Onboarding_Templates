#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "Project Owner"
echo "BigQuery Admin"
echo "Please ensure that this script is running in GCLOUD CONSOLE SHELL"
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT 
if [ -f vars.tfvars ]; then
  echo vars.tfvars exists.
  terraform init
  terraform apply -var-file="vars.tfvars" -auto-approve
  echo "Approved"
else 
read -p "Please enter the project id: " projectid
read -p "Please enter the bucket location: " bucketloc
read -p "Please enter the tableid: " tableid
if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
     # exiting with return code 0
   echo 'Exiting..'
   exit 0

elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
terraform init
bq query --display_name=auth-bq --location=$bucketloc --project_id=$projectid --batch --use_legacy_sql=false --schedule='None' "DECLARE"
cat <<EOF > ./vars.tfvars
project_id = "$projectid"
bucket_location = "$bucketloc"
table_id = "$tableid"
EOF
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi
fi