# provider "aws" {
#   region = "eu-west-3"
# }

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "mi-cluster-dad"
  cluster_version = "1.31"
  vpc_id          = "vpc-002427d5be38383d7"
  subnet_ids      = ["subnet-0717aac9526c9ff4b", "subnet-00f809b073695b201" ]

# Configure public and private endpoint access
  cluster_endpoint_public_access = true  # Enable public access
  cluster_endpoint_private_access = true # Disable private access (optional)

  eks_managed_node_groups = {
    my-node-group = {
        desired_size = 2
        max_size = 3
        min_size = 1

        instance_types = ["t3.small"]
    }
  } 
  

}
