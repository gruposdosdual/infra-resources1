provider "aws" {
  region = "eu-west-3"
  profile = "248189943700_EKS-alumnos"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_s3_bucket" "bucket" { 
  bucket = "practica-recursos3" 
} 

# Crear Rol IAM para Lambda

resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Adjuntar políticas al rol IAM
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}


resource "aws_lambda_function" "lambda" { 
  function_name = "practica_recursos_3" 
  s3_bucket     = aws_s3_bucket.bucket.bucket 
  s3_key        = "lambda-code.zip" 
  runtime        = "nodejs14.x" 
  handler        = "index.handler" 

  role = aws_iam_role.lambda_role.arn  # Rol IAM requerido
  
  depends_on = [aws_s3_bucket.bucket]  # Asegura que el Bucket se cree antes de la función Lambda 
} 