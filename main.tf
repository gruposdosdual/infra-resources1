module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "s3_bucket0" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name1
}

# module "s3_bucket" {
#     source = "git::https://github.com/gruposdosdual/modules-aws-infra/tree/primermoduloAntonio.git"
#     bucket_name = var.bucket_name
# }