# simple_aws_landing_zone
Terraform Deployment of a simple landing zone

# TODO

- Create a NAT Gateway
  - In separate repo, build packer AMI for Gateway
- Create a service for a nat gateway that uses the AMI

# Setup

## Create

Create a profle with the root API keys

```bash
./initialise_from_root_account.sh
```

This will
 - Create a Remote S3 bucket
 - Create a DynammoDB table to store the lock state of the remote tfstate
 - Encrypt the tfstate using a KMS key
 - Create VPC
 - Create an internet gateway
 - Create a public subnet in each AZ for the region
 - Cretae a routing table association for the public subnet to the IGW
 - Create a private subnet for each AZ in the region

## Destroy

```bash
./destroy_from_root_account.sh
```
> Currently fails to remove the S3 bucket for the remote state storage. 
