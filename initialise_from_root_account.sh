#!/usr/bin/env bash

# Create Terraform Backend
account="production"
region="eu-west-1"
bucket="ew1-tf-backend"
profile="aws-root"

# Remote State
pushd core/remote-state &> /dev/null

terraform get -update

terraform init -backend=false                         

terraform                                                                     \
    plan                                                                      \
    -out=backend.plan                                                         \
    -target=module.backend                                                    \
    -var "backend_bucket=${bucket}"

terraform apply backend.plan

popd &> /dev/null

# Organisations
pushd core/accounts &> /dev/null
terraform                                                                     \
    init                                                                      \
    -backend-config="profile=${profile}"                                      \
    -backend-config="region=${region}"                                        \
    -backend-config="bucket=${bucket}"                                        \
    -backend-config="key=states/${account}.tfstate"                           \
    -backend-config="encrypt=true"                                            \
    -backend-config="dynamodb_table=terraform-lock"

terraform                                                                     \
    plan                                                                      \
    -out=accounts.plan                                                        \
    -var-file="vars/accounts.tfvars.json"

terraform apply accounts.plan

popd &> /dev/null

exit

# VPC - Need to run this for each organizational unit
pushd core/vpc &> /dev/null

terraform                                                                     \
    init                                                                      \
    -backend-config="profile=${profile}"                                      \
    -backend-config="region=${region}"                                        \
    -backend-config="bucket=${bucket}"                                        \
    -backend-config="key=states/${account}.tfstate"                           \
    -backend-config="encrypt=true"                                            \
    -backend-config="dynamodb_table=terraform-lock"                           \
    -var-file="vars/${account}-${region}.tfvars"      

terraform                                                                     \
    apply                                                                     \
    -var-file="vars/${account}-${region}.tfvars"      

popd &> /dev/null