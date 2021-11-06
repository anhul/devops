# Terraform configuration

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "aws-private"
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "jenkins-master"
  instance_count = 1

  ami                    = "ami-0629230e074c580f2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-039f097603511cc9c"]
  subnet_id              = "subnet-52c59c1e"

  tags = {
    Jenkins   = "master"
  }
}
