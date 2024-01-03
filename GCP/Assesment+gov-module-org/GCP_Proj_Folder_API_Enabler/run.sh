!/bin/bash 
read -p "Please enter the folder id: " folder_id
cat <<EOF > ./vars.tfvars
folder_id = "$folder_id"
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
