terraform {
  source = "./"
}

/*

include {
  path = find_in_parent_folders()
}
*/

/*
inputs ={
    bucket_name = "terragrunt-state-storage-fjgl"    
}
*/

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-storage-248189943700-fj" # Nombre del bucket S3
    key            = "state/terragrunt-pra/terraform.tfstate" # Ubicación del archivo de estado
    region         = "eu-west-3" # Región del bucket S3
    profile        = "248189943700_EKS-alumnos"
    #dynamodb_table = "terraform-locks" # Nombre de la tabla DynamoDB para bloqueo
  }
}

# Definición de dependencias (entornos dev y prod)
dependencies {
  paths = [
    "./dev",
    "./prod"
  ]
}

