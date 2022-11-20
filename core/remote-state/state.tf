# Create backend bucket

module backend {
  source          = "../../modules/backend"
  backend_bucket  = "${var.backend_bucket}"
}
