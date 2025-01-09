Cambios Realizados:
Rol IAM (aws_iam_role):

Se agregó un rol de ejecución para la función Lambda con una política mínima para registrar logs.
Política IAM (aws_iam_role_policy):

Se agregó una política para permitir a Lambda escribir en CloudWatch Logs.
Corrección de referencias:

Se corrigió la referencia al bucket en aws_lambda_function de aws_s3_bucket.bucket.practica_recursos3 a aws_s3_bucket.bucket.bucket.