terraform{
    source = "./"
}

inputs = {
    bucket_name = "terragrunt-bucket-dad"
    aws_profile = "EKS-alumnos-248189943700"
}

remote_state { 
  backend = "s3" 
  config = { 
    bucket         = "terraform-state-storage-dad" 
    key            = "state/terragrunt-pra/terraform.tfstate" 
    region         = "eu-west-3" 
  } 
} 
