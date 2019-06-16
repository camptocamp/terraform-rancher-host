#!/bin/bash

vagrant up

sleep 120

terraform init
terraform plan
terraform apply -auto-approve

vagrant destroy -f
