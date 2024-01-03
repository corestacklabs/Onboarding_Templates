!/bin/bash 
read -p "Please enter the Billing id: " bill_id
cat <<EOF > ./vars.tfvars
billing_id = "$bill_id"
EOF
terraform init
terraform apply -var-file="vars.tfvars" -auto-approve
echo "Approved"
