/*module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}*/

module "s3_bucket" {
    source = "git::https://github.com/gruposdosdual/infra-resources1.git//modules/s3"
    bucket_name = var.bucket_name
}


module "s3_bucket_1" {
    source = "git::https://github.com/gruposdosdual/infra-resources1.git//modules/s3"
    bucket_name = var.bucket_name1
}