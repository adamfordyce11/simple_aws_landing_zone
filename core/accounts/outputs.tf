# Output the account name and id

#output "account_name" {
#  count       = length(var.accounts)
#  description = "Account Name"
#  value       = "aws_organizations_organizational_unit.${var.accounts[count.index].account_name}.id"
#}