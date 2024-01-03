# Terraform file for the creation of service account and providing access

#Header start
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}


resource "null_resource" "Project_script" {
 provisioner "local-exec" {  
    command = "/usr/bin/python3 extractor.py ${var.billing_id}"
  }
}

