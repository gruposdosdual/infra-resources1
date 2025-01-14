terraform {
  source = "../.."
}

/*

include {
  path = find_in_parent_folders()
}
*/
inputs = {
  bucket_name = "dev-terragrunt-bucket-248189943700"
  environment = "dev"
  tags = {
    Environment = "dev"
  }
}
