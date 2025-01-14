terraform { 
  source = "../s3-bucket" 
}



inputs = {
  bucket_name = "prod-terragrunt-bucket-248189943700"
  environment = "prod"  
}

