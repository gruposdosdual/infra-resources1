resource "aws_ecr_repository" "my_ecr_repo" {
  name                 = "my-ecr-repo-dad"
  image_tag_mutability = "MUTABLE"  
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.my_ecr_repo.repository_url
}

resource "aws_iam_user" "mi_usuario" {
  name = "dad-usuario"
}


resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowPushPull",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::248189943700:user/dad-usuario"
        },
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  }
  POLICY
}

resource "null_resource" "upload_image" {
  provisioner "local-exec" {
    command = <<EOT
    # Authenticate Docker to ECR (use your actual account ID)
    aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 248189943700.dkr.ecr.eu-west-3.amazonaws.com

    # Build Docker image
    docker build -t 248189943700.dkr.ecr.eu-west-3.amazonaws.com/my-ecr-repo-dad:latest .

    # Push Docker image to ECR
    docker push 248189943700.dkr.ecr.eu-west-3.amazonaws.com/my-ecr-repo-dad:latest
    EOT
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name

  policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Eliminar imágenes no etiquetadas después de 30 días",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
}
