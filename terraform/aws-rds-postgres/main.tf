# Terraform configuration

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "aws-private"
}

data "aws_vpc" "default" {
  default = true
}

locals {
  tags = {
    Environment = "test"
  }
}

resource "aws_db_instance" "postgres_db" {

  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  name     = var.name
  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = [module.postgres_public_sg.security_group_id]
  db_subnet_group_name   = var.db_subnet_group_name

  publicly_accessible = var.publicly_accessible

  backup_retention_period = var.backup_retention_period
  max_allocated_storage   = var.max_allocated_storage

  skip_final_snapshot = var.skip_final_snapshot

  tags = local.tags

}

module "postgres_public_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  vpc_id      = data.aws_vpc.default.id
  name        = "postgres-public"
  description = "Security group for Postgres"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["postgresql-tcp"]
}

