
#data "terraform_remote_state" "state" {
#  backend = "s3"
#  config {
#    bucket     = var.stateBucketName
#    lock_table = var.stateBucketLockTable
#    region     = var.stateBucketRegion
#    key        = var.stateBucketKey
#  }
#}