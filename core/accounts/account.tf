# https://cloudly.engineer/2020/create-new-aws-accounts-with-organizations-and-terraform/aws/

# TODO: In tf vars pass in the accounts as a list rather than one by one

resource "aws_organizations_organizational_unit" "workload" {
  name      = "workload"
  parent_id = aws_organizations_organization.this.roots[0].id
}


resource "aws_organizations_organizational_unit" "account" {
  count          = length(var.accounts)
  name           = var.accounts[count.index].account_name
  parent_id      = aws_organizations_organizational_unit.workload.id

  depends_on = [
    aws_organizations_organizational_unit.workload
  ]
}

resource "aws_organizations_account" "account" {
  count          = length(var.accounts)
  # A friendly name for the member account
  name           = var.accounts[count.index].account_name
  email          = var.accounts[count.index].account_email

  # Enables IAM users to access account billing information 
  # if they have the required permissions
  iam_user_access_to_billing = "ALLOW"

  tags = {
    Name  = "${var.accounts[count.index].account_name}"
    Owner = "${var.accounts[count.index].owner}"
    Role  = "${var.accounts[count.index].role}"
  }

  parent_id = aws_organizations_organizational_unit.account[count.index].id
}