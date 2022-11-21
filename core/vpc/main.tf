module vpc {
  count           = length(var.accounts)

  source             = "../../modules/vpc"
  account            = var.accounts[count.index].account_name
  region             = var.accounts[count.index].account_name
  account_cidr_start = var.accounts[count.index].cidr_start
  account_cidr_end   = var.accounts[count.index].cidr_end
}