echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "- Organization level Security Admin Role"
echo "- Service Usage Admin"
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT
if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
   echo 'Exiting..'
   exit 0 
elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
read -p "Please enter the Organisation id: " org_id
read -p "Please enter the service account email: " svcacc
read -p "Do you need to retrive vunrelabilities and threat from GCP console? specify yes or no:" secops
if [ "${secops}" == "No" ] || [ "${secops}" == "no" ] ; then
cat <<EOF > ./vars.tfvars
org_id = "$org_id"
service_account_email = "$svcacc"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
EOF
elif [ "${secops}" == "Yes" ] || [ "${secops}" == "yes" ] ; then
cat <<EOF > ./vars.tfvars
org_id = "$org_id"
service_account_email = "$svcacc"
permissionsec = "Yes"
api = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi