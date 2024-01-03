!/bin/bash 
read -p "Please enter the Org id: " org_id
cat <<EOF > ./vars.tfvars
org_id = "$org_id"
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
