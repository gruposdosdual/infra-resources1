/*module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}*/

/*resource "aws_dynamodb_table" "example" {
  name             = "example"
  hash_key         = "TestTableHashKey"
  billing_mode     = "PAY_PER_REQUEST"
  

  attribute {
    name = "LockId"
    type = "S"
  }
}
*/



module "s3_bucket" {
    source = "git::https://github.com/gruposdosdual/infra-resources1.git//modules/s3"
    bucket_name = var.bucket_name
}


module "s3_bucket_1" {
    source = "git::https://github.com/gruposdosdual/infra-resources1.git//modules/s3"
    bucket_name = var.bucket_name1
}

terraform {   
 backend "s3" {
    bucket         = "test-bucket-43120896345235"        
    key            = "./terraform.tfstate"      
   region         = "eu-west-3"       
   dynamodb_table = "example"  
   }    
  }
  