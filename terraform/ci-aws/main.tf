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

data "aws_vpc" "default" {
  default = true
}

module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "jenkins-master"
  instance_count = 1

  ami                    = "ami-0629230e074c580f2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.jenkins_ui_sg.security_group_id, module.jenkins_ssh_sg.security_group_id, module.jenkins_http_sg.security_group_id]
  subnet_id              = "subnet-52c59c1e"
  key_name = var.key_name

  tags = {
    Jenkins   = "master"
  }
}

module "jenkins_ui_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id      = data.aws_vpc.default.id
  name        = "jenkins-ui"
  description = "Security group for Jenkins UI access"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-8080-tcp"]
}
module "jenkins_http_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id      = data.aws_vpc.default.id
  name        = "jenkins-http"
  description = "Security group for incomint and outcoming HTTP traffic"

  egress_rules        = [ "all-all" ]
}
module "jenkins_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id      = data.aws_vpc.default.id
  name        = "jenkins-ssh"
  description = "Security group for ssh access to Jenkins servers"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
}
