terraform { 
  source = "../s3-bucket"
}

inputs = {
  bucket_name = "dev-terragrunt-bucket-248189943700"
  environment = "dev"  
}
