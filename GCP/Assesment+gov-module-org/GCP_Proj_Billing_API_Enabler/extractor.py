import os
import sys
args = sys.argv
billing_proj_id = args[1]
os.system(f"gcloud billing projects list --billing-account={billing_proj_id} --format=json | jq -r '.[].projectId' > li_p.txt")
f = open("li_p.txt", "r")
li = []
for x in f:
    li.append(x)
#   if "PROJECT_ID:" in x:
#     y = x.split(" ")
#     li.append(y[-1])
li_ = []
for i in li:
    i = i[:-1]
    li_.append(i)

f.close()



os.system("terraform -chdir=./api-runner/ init")
for i in li_:
    vf = open("api-runner/api.tfvars","w")
    vf.write(f'billproject = "{i}"')
    vf.close()
    os.system(f'terraform -chdir=./api-runner/ apply -auto-approve -var-file="api.tfvars"')
    os.system("rm -rf ./api-runner/terraform.tfstat*")
