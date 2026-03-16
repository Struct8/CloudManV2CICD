terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cloudan-v2-cicd"
    key            = "952133486861/StatefulECS/main.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

# --- Main Cloud Provider ---
provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

### CATEGORY: NETWORK ###

resource "aws_vpc" "WordPress3" {
  cidr_block                        = "10.0.0.0/16"
  enable_dns_hostnames              = true
  enable_dns_support                = true
  instance_tenancy                  = "default"
  tags                              = {
    "Name" = "WordPress3"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "DB_a1" {
  vpc_id                            = aws_vpc.WordPress3.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.0.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "DB_a1"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "DB_b1" {
  vpc_id                            = aws_vpc.WordPress3.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.2.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "DB_b1"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "EFS_a1" {
  vpc_id                            = aws_vpc.WordPress3.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.0.1.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "EFS_a1"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "EFS_b1" {
  vpc_id                            = aws_vpc.WordPress3.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.0.3.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "EFS_b1"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_internet_gateway" "IGW3" {
  vpc_id                            = aws_vpc.WordPress3.id
  tags                              = {
    "Name" = "IGW3"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "db_instance_database4_group" {
  name                              = "db_instance_database4_group"
  vpc_id                            = aws_vpc.WordPress3.id
  description                       = "SG RDS"
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "db_instance_database4_group"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "efs_file_system_EFS2_group" {
  name                              = "efs_file_system_EFS2_group"
  vpc_id                            = aws_vpc.WordPress3.id
  description                       = "SG EFS"
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "efs_file_system_EFS2_group"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}




### CATEGORY: STORAGE ###

resource "aws_s3_bucket" "s3-off-load-wp-abcd1" {
  bucket                            = "s3-off-load-wp-abcd1"
  force_destroy                     = true
  object_lock_enabled               = false
  tags                              = {
    "Name" = "s3-off-load-wp-abcd1"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-off-load-wp-abcd1_controls" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd1.id
  rule {
    object_ownership                = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-off-load-wp-abcd1_block" {
  block_public_acls                 = true
  block_public_policy               = true
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd1.id
  ignore_public_acls                = true
  restrict_public_buckets           = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-off-load-wp-abcd1_configuration" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd1.id
  expected_bucket_owner             = data.aws_caller_identity.current.account_id
  rule {
    bucket_key_enabled              = true
  }
}

resource "aws_s3_bucket_versioning" "s3-off-load-wp-abcd1_versioning" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd1.id
  versioning_configuration {
    mfa_delete                      = "Disabled"
    status                          = "Suspended"
  }
}

resource "aws_db_instance" "database4" {
  db_name                           = "wordpress"
  db_subnet_group_name              = aws_db_subnet_group.subnet_group_database4.name
  allocated_storage                 = 20
  availability_zone                 = aws_subnet.DB_a1.availability_zone
  backup_retention_period           = 0
  copy_tags_to_snapshot             = true
  delete_automated_backups          = false
  engine                            = "mysql"
  engine_version                    = "8.0"
  iam_database_authentication_enabled = true
  identifier                        = "database4"
  instance_class                    = "db.t3.micro"
  manage_master_user_password       = true
  max_allocated_storage             = 100
  skip_final_snapshot               = true
  storage_encrypted                 = true
  storage_type                      = "gp3"
  upgrade_storage_config            = false
  username                          = "admin"
  vpc_security_group_ids            = [aws_security_group.db_instance_database4_group.id]
  tags                              = {
    "Name" = "database4"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_db_subnet_group" "subnet_group_database4" {
  name                              = "database4-subnet-group"
  subnet_ids                        = [aws_subnet.DB_a1.id, aws_subnet.DB_b1.id]
  tags                              = {
    "Name" = "subnet_group_database4"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_file_system" "EFS2" {
  encrypted                         = true
  throughput_mode                   = "elastic"
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  protection {
    replication_overwrite           = "ENABLED"
  }
  tags                              = {
    "Name" = "EFS2"
    "State" = "StatefulECS"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_mount_target" "mt_EFS2_EFS_a1" {
  file_system_id                    = aws_efs_file_system.EFS2.id
  subnet_id                         = aws_subnet.EFS_a1.id
  security_groups                   = [aws_security_group.efs_file_system_EFS2_group.id]
}

resource "aws_efs_mount_target" "mt_EFS2_EFS_b1" {
  file_system_id                    = aws_efs_file_system.EFS2.id
  subnet_id                         = aws_subnet.EFS_b1.id
  security_groups                   = [aws_security_group.efs_file_system_EFS2_group.id]
}


