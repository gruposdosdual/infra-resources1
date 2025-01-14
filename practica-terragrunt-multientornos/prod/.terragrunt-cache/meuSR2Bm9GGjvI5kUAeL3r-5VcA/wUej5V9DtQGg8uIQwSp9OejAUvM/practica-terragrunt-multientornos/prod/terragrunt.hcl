terraform {
  source = "../.."
}

/*
include {
  path = find_in_parent_folders()
}
*/

inputs = {
  bucket_name = "prod-terragrunt-bucket-248189943700"
  environment = "prod"
  tags = {
    Environment = "prod"
  }
}

