#!/usr/bin/env bash

# Create IAM Policies

# Create Organizations

# Create Accounts

# Artifact Creation
#  - Get k3s
#  - Packages for hosts (create yum/apt repo)
#     - OSSEC
#     - WAZUH

# Create AMIs
#  - base AMI
#  - OSSEC
#  - WAZUH
#  - OpenVPN
#  - bastion host / NAT Gateway
#  - k3s node

# For Each Account

# Create Terraform Backend
account="production"
region="eu-west-1"
bucket="ew1-tf-backend"
profile="aws-root"

pushd core/remote-state &> /dev/null

terraform get -update
terraform init -backend=false                         
terraform plan -out=backend.plan -target=module.backend -var "backend_bucket=${bucket}"
terraform apply backend.plan

popd &> /dev/null

pushd core/vpc &> /dev/null

terraform                                             \
    init                                              \
    -backend-config="profile=${profile}"              \
    -backend-config="region=${region}"                \
    -backend-config="bucket=${bucket}"                \
    -backend-config="key=states/${account}.tfstate"   \
    -backend-config="encrypt=true"                    \
    -backend-config="dynamodb_table=terraform-lock"   \
    -var-file="vars/${account}-${region}.tfvars"      

terraform                                             \
    apply                                             \
    -var-file="vars/${account}-${region}.tfvars"      

popd &> /dev/null