terraform {
  backend "s3" {
    bucket       = "starttech-tfstate-334298573726"
    key          = "starttech/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
