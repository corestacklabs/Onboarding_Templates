#!/bin/bash
echo "Please ensure you have the necessary IAM permissions .The execution of this script requires following user account permissions: "
echo "Organization Admin or Security Admin"
read -p "Please specify yes if above pre-requisites met or specify no : " INPUT 

if [ "${INPUT}" == "No" ] || [ "${INPUT}" == "no" ] ; then
     # exiting with return code 0
   echo 'Exiting..'
   exit 0

elif [ "${INPUT}" == "Yes" ]||[ "${INPUT}" == "yes" ] ; then   
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
fi