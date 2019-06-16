#!/bin/bash

echo "[*] Installing Terraform..."
wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip -O - | funzip > /bin/terraform

chmod +x /bin/terraform
terraform

echo "[*] Installing Terraform plugins..."
mkdir -p /home/vagrant/.terraform.d/plugins
wget https://github.com/camptocamp/terraform-provisioner-ansible/releases/download/tf-v0.12/terraform-provisioner-ansible.zip -O - | funzip > /home/vagrant/.terraform.d/plugins/terraform-provisioner-ansible
chmod +x /home/vagrant/.terraform.d/plugins/terraform-provisioner-ansible

sync
