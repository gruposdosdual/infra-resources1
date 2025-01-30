output "InstanceIpExample" {
  value = aws_instance.new_EC2.public_ip
}