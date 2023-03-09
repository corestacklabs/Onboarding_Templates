import os
os.system("terraform output > li_p.txt")
f = open("li_p.txt", "r")
li = []
for x in f:
  if "project_id" in x:
    y = x.split(" ")
    li.append(y[-1])
li_ = []
for i in li:
    i = i[1:-2]
    li_.append(i)

f.close()



vaf = open("vars.tfvars","r")
x = ''
for i in vaf:
    if "api =" in i:
     x =  i   
vaf.close()
os.system("terraform -chdir=./api-runner/ init")
for i in li_:
    vf = open("api-runner/api.tfvars","w")
    vf.write(f'''orgproject = "{i}"
    {x}''')
    vf.close()
    os.system(f'terraform -chdir=./api-runner/ apply -auto-approve -var-file="api.tfvars"')
    os.system("rm -rf ./api-runner/terraform.stat*")
