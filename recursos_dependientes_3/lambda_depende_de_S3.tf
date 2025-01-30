resource "aws_s3_bucket" "bucket" { 
  bucket = "practica_recursos3" 
} 
# resource "aws_lambda_function" "lambda" { 
#   function_name = "practica_recursos-3" 
#   s3_bucket     = aws_s3_bucket.bucket.practica_recursos3 
#   s3_key        = "lambda-code.zip" 
#   runtime        = "nodejs14.x" 
#   handler        = "index.handler" 
  
#   depends_on = [aws_s3_bucket.bucket]  # Asegura que el Bucket se cree antes de la función Lambda 
# } 