# https://cloudly.engineer/2020/create-new-aws-accounts-with-organizations-and-terraform/aws/

# TODO: In tf vars pass in the accounts as a list rather than one by one

resource "aws_organizations_organizational_unit" "workload" {
  name      = "workload"
  parent_id = aws_organizations_organization.this.roots[0].id
}


resource "aws_organizations_organizational_unit" "dev" {
  name      = vars.account_name
  parent_id = aws_organizations_organizational_unit.workload.id

  depends_on = [
    aws_organizations_organizational_unit.workload
  ]
}

resource "aws_organizations_account" "dev" {
  # A friendly name for the member account
  name  = vars.account_name
  email = vars.account_email

  # Enables IAM users to access account billing information 
  # if they have the required permissions
  iam_user_access_to_billing = "ALLOW"

  tags = {
    Name  = "${vars.account_name}"
    Owner = "${vars.owner}"
    Role  = "${vars.role}"
  }

  parent_id = "aws_organizations_organizational_unit.${vars.account_name}.id"
}