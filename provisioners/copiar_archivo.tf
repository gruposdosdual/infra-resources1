# provider "aws" {
#   region  = "eu-west-3"
#   profile = "EKS-alumnos-248189943700"
# }

# resource "aws_instance" "practica_provisioner_DAD" {
#   ami           = "ami-07dc1ccdcec3b4eab"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "provisioner_DA"
#   }
#     security_groups = [ "ProvisionesDA_securitygroup" ]

#   provisioner "file" {
#     source      = "./config.cfg"
#     destination = "./temp/config.cfg"

#     connection {
#       type        = "ssh"
#       host        = self.public_ip
#       user        = "ubuntu"
#       private_key = file("provisioner_DA.pem")
#     }
#   }
# }


provider "aws" {
  region = "eu-west-3"
  profile = "EKS-alumnos-248189943700"
}
 
# Crear una VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
 
  tags = {
    Name = "provisioner_DA"
  }
}
 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway_provisioner_DA"
  }
}
 
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "Subnet_provisioner_DA"
  }
}
 
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Table-jgl"
  }
}
 
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}
 
 
 
 
# Crear un grupo de seguridad
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id  # Asegúrate de que el VPC esté definido
 
  # Regla de entrada para permitir tráfico SSH (puerto 22)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir desde cualquier IP (o usa una IP específica)
  }
 
  # Regla de salida para permitir todo el tráfico
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
 
resource "aws_instance" "practica_provisioner" {
  ami           = "ami-07dc1ccdcec3b4eab" # Cambia por un AMI válido.
  instance_type = "t2.micro"
  key_name      = "provisioner_DA"       # Cambia por una clave SSH válida.
  subnet_id     = aws_subnet.subnet.id  # Asegúrate de que la subred esté definida
 
  # Usa vpc_security_group_ids en lugar de security_groups
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 
  # Creamos la instancia y aseguramos que tenga IP pública
  associate_public_ip_address = true
 
  # Espera a que la instancia esté completamente creada
  depends_on = [aws_security_group.allow_ssh]
 
  tags = {
    Name = "Practica-Provisioner-FJGL"
  }
}
 
resource "null_resource" "provision_file" {
  depends_on = [aws_instance.practica_provisioner]
 
  provisioner "remote-exec" {
    connection {
        type        = "ssh"
        user        = "ubuntu"     # Cambia según el AMI (puede ser 'ubuntu' o 'root').
        private_key = file("provisioner_DA.pem") # Cambia a la ruta correcta de tu clave privada.
        #host        = self.public_ip
        host        = aws_instance.practica_provisioner.public_ip  # Uso de la IP pública correcta.
        #timeout     = "5m" # Aumenta el tiempo de espera a 5 minutos
  }
 
    inline = [
        "echo 'Configurando la instancia' > /tmp/config.cfg",
        "sudo mv /tmp/config.cfg /home/ubuntu/config.cfg"
    ]
  }
}
/*
 
  provisioner "file" {
    source      = "config.cfg"
    destination = "/tmp/config.cfg"
  }
*/
 
 
output "instance_public_ip" {
  value = aws_instance.practica_provisioner.public_ip
}