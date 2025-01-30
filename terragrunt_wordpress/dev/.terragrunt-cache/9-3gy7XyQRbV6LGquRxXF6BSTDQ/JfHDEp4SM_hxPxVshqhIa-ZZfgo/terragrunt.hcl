terraform{
    source = "../modules"
}

inputs = {
    # VPC
    vpc_id = "vpc-002427d5be38383d7"

    #EC2
    ami_id = "ami-07db896e164bc4476"
    instance_type = "t2.small"
    ec2_key_name = "provisioner_DA"

    #RDS
    db_identifier = "my-database-instance-dad"
    db_engine = "mysql" 
    db_engine_version = "8.0"
    db_instance_class = "db.t4g.micro"
    db_storage = 5
    db_storage_type = "gp2"
    db_name = "mydatabaseDAD"
    db_user = "admin"
    db_password = "password123!"
}
