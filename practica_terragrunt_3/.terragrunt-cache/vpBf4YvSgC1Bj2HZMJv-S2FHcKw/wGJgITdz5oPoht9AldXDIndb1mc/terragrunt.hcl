terraform {
  source = "./"
}

inputs ={
    bucket_name = "terragrunt-state-storage-jgl"    
}


remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-storage-jgl" # Nombre del bucket S3
    key            = "state/terragrunt-pra/terraform.tfstate" # Ubicación del archivo de estado
    region         = "eu-west-3" # Región del bucket S3
    #dynamodb_table = "terraform-locks" # Nombre de la tabla DynamoDB para bloqueo
  }
}

