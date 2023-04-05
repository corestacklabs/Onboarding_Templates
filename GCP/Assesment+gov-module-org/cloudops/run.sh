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
   echo 'Exiting..'
   exit 0 
elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
read -p "Please enter the Organisation id: " org_id
read -p "Please enter the project id: " proj_id
read -p "Please enter the service account email: " svcacc
cat <<EOF > ./vars.tfvars
org_id = "$org_id"
project_id = "$proj_id"
service_account_email = "$svcacc"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi
fi