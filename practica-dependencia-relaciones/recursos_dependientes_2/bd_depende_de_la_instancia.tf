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

resource "aws_db_instance" "practica_recurso2" { 
  identifier        = "practica-recurso2-db" 
  engine            = "mysql" 
  instance_class    = "db.t4g.micro" 
  allocated_storage = 20 
  username          = "admin" 
  password          = "password" 
  db_name           = "primeradb" 
  publicly_accessible = true 
} 

resource "aws_instance" "practica_recursos2_instance" { 
    ami           = "ami-09be70e689bddcef5"  # Reemplaza con una AMI válida 
    instance_type = "t2.micro" 
    subnet_id     = aws_subnet.subnet.id 
    depends_on = [aws_db_instance.practica_recurso2]  # La instancia EC2 depende de la base de datos RDS 
} 


/*
resource "aws_security_group" "practica_recursos" {     
    name_prefix = "practica_recursos-" 
    description = "Allow inbound traffic" 
    vpc_id = aws_vpc.main.id 

    ingress { 
        from_port = 22 
        to_port = 22 
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"] 
    } 
} 

*/





