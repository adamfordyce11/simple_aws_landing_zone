# Output the account name and id

output "account_name" {
  description = "Account Name"
  value       = "aws_organizations_organizational_unit.${vars.account_name}.id"
}