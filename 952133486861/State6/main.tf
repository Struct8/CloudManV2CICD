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
    key            = "952133486861/State6/main.tfstate"
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

### SYSTEM DATA SOURCES ###

data "aws_route53_zone" "Zone1" {
  name                              = "Zone1"
}

data "aws_cloudfront_cache_policy" "policy_cachingoptimized" {
  name                              = "Managed-CachingOptimized"
}

data "aws_cloudfront_response_headers_policy" "policy_simplecors" {
  name                              = "Managed-SimpleCORS"
}




### CATEGORY: IAM ###

resource "aws_iam_instance_profile" "profile_Instance3" {
  name                              = "profile_Instance3"
  role                              = aws_iam_role.role_ec2_Instance3.name
  tags                              = {
    "Name" = "profile_Instance3"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

data "aws_iam_policy_document" "instance_Instance3_st_State6_doc" {
  statement {
    sid                             = "AllowRDSSecretAccessdatabase6"
    effect                          = "Allow"
    actions                         = ["secretsmanager:DescribeSecret", "secretsmanager:GetSecretValue"]
    resources                       = ["${aws_db_instance.database6.master_user_secret[0].secret_arn}"]
  }
  statement {
    sid                             = "AllowBucketLevelActions"
    effect                          = "Allow"
    actions                         = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources                       = ["${aws_s3_bucket.s3-off-load-wp-abcd5.arn}"]
  }
  statement {
    sid                             = "AllowObjectCRUD"
    effect                          = "Allow"
    actions                         = ["s3:DeleteObject", "s3:GetObject", "s3:PutObject"]
    resources                       = ["${aws_s3_bucket.s3-off-load-wp-abcd5.arn}/*"]
  }
  statement {
    sid                             = "AllowBucketLevelActions1"
    effect                          = "Allow"
    actions                         = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources                       = ["${aws_s3_bucket.wp-script-cloudman2.arn}"]
  }
  statement {
    sid                             = "AllowObjectCRUD1"
    effect                          = "Allow"
    actions                         = ["s3:GetObject"]
    resources                       = ["${aws_s3_bucket.wp-script-cloudman2.arn}/*"]
  }
  statement {
    sid                             = "EC2AndConsoleAccess"
    effect                          = "Allow"
    actions                         = ["ec2-instance-connect:SendSSHPublicKey", "ec2:DescribeInstances", "ec2:GetConsoleOutput", "ec2:GetConsoleScreenshot", "ec2:SendSerialConsoleSSHPublicKey", "ssm:UpdateInstanceInformation", "ssmmessages:CreateControlChannel", "ssmmessages:CreateDataChannel", "ssmmessages:OpenControlChannel", "ssmmessages:OpenDataChannel"]
    resources                       = ["*"]
  }
}

resource "aws_iam_policy" "instance_Instance3_st_State6" {
  name                              = "instance_Instance3_st_State6"
  description                       = "Access Policy for Instance3"
  policy                            = data.aws_iam_policy_document.instance_Instance3_st_State6_doc.json
}

resource "aws_iam_role" "role_ec2_Instance3" {
  name                              = "role_ec2_Instance3"
  assume_role_policy                = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
})
  tags                              = {
    "Name" = "role_ec2_Instance3"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_iam_role_policy_attachment" "instance_Instance3_st_State6_attach" {
  policy_arn                        = aws_iam_policy.instance_Instance3_st_State6.arn
  role                              = aws_iam_role.role_ec2_Instance3.name
}

resource "aws_acm_certificate" "Certificate1" {
  domain_name                       = "wp.Zone1"
  key_algorithm                     = "RSA_2048"
  validation_method                 = "DNS"
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  tags                              = {
    "Name" = "Certificate1"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_acm_certificate_validation" "Validation_Certificate1" {
  certificate_arn                   = aws_acm_certificate.Certificate1.arn
  validation_record_fqdns           = [for record in aws_route53_record.Route53_Record_Certificate1 : record.fqdn]
}




### CATEGORY: NETWORK ###

resource "aws_vpc" "WordPress4" {
  cidr_block                        = "10.7.0.0/16"
  enable_dns_hostnames              = true
  enable_dns_support                = true
  instance_tenancy                  = "default"
  tags                              = {
    "Name" = "WordPress4"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "DB_a5" {
  vpc_id                            = aws_vpc.WordPress4.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.7.0.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "DB_a5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "DB_b5" {
  vpc_id                            = aws_vpc.WordPress4.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.7.1.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "DB_b5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "EFS_a5" {
  vpc_id                            = aws_vpc.WordPress4.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.7.2.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "EFS_a5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "EFS_b5" {
  vpc_id                            = aws_vpc.WordPress4.id
  availability_zone                 = "us-east-1b"
  cidr_block                        = "10.7.3.0/24"
  map_public_ip_on_launch           = false
  tags                              = {
    "Name" = "EFS_b5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_subnet" "WP2" {
  vpc_id                            = aws_vpc.WordPress4.id
  availability_zone                 = "us-east-1a"
  cidr_block                        = "10.7.4.0/24"
  map_public_ip_on_launch           = true
  tags                              = {
    "Name" = "WP2"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_internet_gateway" "IGW6" {
  vpc_id                            = aws_vpc.WordPress4.id
  tags                              = {
    "Name" = "IGW6"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route" "aws_route_RT6_IGW6" {
  gateway_id                        = aws_internet_gateway.IGW6.id
  route_table_id                    = aws_route_table.RT6.id
  destination_cidr_block            = "0.0.0.0/0"
}

resource "aws_route53_record" "Route53_Record_Certificate1" {
  for_each                          = {for dvo in aws_acm_certificate.Certificate1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name,
      record = dvo.resource_record_value,
      type   = dvo.resource_record_type
    }}
  name                              = "${each.value.name}"
  zone_id                           = data.aws_route53_zone.Zone1.zone_id
  allow_overwrite                   = true
  records                           = ["${each.value.record}"]
  ttl                               = 300
  type                              = "${each.value.type}"
}

resource "aws_route53_record" "alias_a_aws_cloudfront_distribution_CDN6" {
  name                              = "wp.Zone1"
  zone_id                           = data.aws_route53_zone.Zone1.zone_id
  type                              = "A"
  alias {
    name                            = aws_cloudfront_distribution.CDN6.domain_name
    zone_id                         = aws_cloudfront_distribution.CDN6.hosted_zone_id
    evaluate_target_health          = false
  }
}

resource "aws_route53_record" "alias_aaaa_aws_cloudfront_distribution_CDN6" {
  name                              = "wp.Zone1"
  zone_id                           = data.aws_route53_zone.Zone1.zone_id
  type                              = "AAAA"
  alias {
    name                            = aws_cloudfront_distribution.CDN6.domain_name
    zone_id                         = aws_cloudfront_distribution.CDN6.hosted_zone_id
    evaluate_target_health          = false
  }
}

resource "aws_route_table" "RT6" {
  vpc_id                            = aws_vpc.WordPress4.id
  tags                              = {
    "Name" = "RT6"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_route_table_association" "aws_route_table_association_WP2_RT6" {
  route_table_id                    = aws_route_table.RT6.id
  subnet_id                         = aws_subnet.WP2.id
}

resource "aws_security_group" "db_instance_database6_group" {
  name                              = "db_instance_database6_group"
  vpc_id                            = aws_vpc.WordPress4.id
  description                       = "SG RDS"
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "db_instance_database6_group"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "efs_file_system_EFS5_group" {
  name                              = "efs_file_system_EFS5_group"
  vpc_id                            = aws_vpc.WordPress4.id
  description                       = "SG EFS"
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "efs_file_system_EFS5_group"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group" "instance_Instance3_group" {
  name                              = "instance_Instance3_group"
  vpc_id                            = aws_vpc.WordPress4.id
  revoke_rules_on_delete            = false
  tags                              = {
    "Name" = "instance_Instance3_group"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_security_group_rule" "rule_instance_Instance3_group_egress_all_protocols" {
  security_group_id                 = aws_security_group.instance_Instance3_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 0
  protocol                          = "-1"
  to_port                           = 0
  type                              = "egress"
}

resource "aws_security_group_rule" "rule_instance_Instance3_group_ingress_tcp_443" {
  security_group_id                 = aws_security_group.instance_Instance3_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 443
  protocol                          = "tcp"
  to_port                           = 443
  type                              = "ingress"
}

resource "aws_security_group_rule" "rule_instance_Instance3_group_ingress_tcp_80" {
  security_group_id                 = aws_security_group.instance_Instance3_group.id
  cidr_blocks                       = ["0.0.0.0/0"]
  from_port                         = 80
  protocol                          = "tcp"
  to_port                           = 80
  type                              = "ingress"
}

resource "aws_security_group_rule" "rule_instance_Instance3_group_to_db_instance_database6_group_tcp_3306" {
  security_group_id                 = aws_security_group.db_instance_database6_group.id
  source_security_group_id          = aws_security_group.instance_Instance3_group.id
  description                       = "Allow from instance_Instance3_group (tcp:3306-3306)"
  from_port                         = 3306
  protocol                          = "tcp"
  to_port                           = 3306
  type                              = "ingress"
}

resource "aws_security_group_rule" "rule_instance_Instance3_group_to_efs_file_system_EFS5_group_tcp_2049" {
  security_group_id                 = aws_security_group.efs_file_system_EFS5_group.id
  source_security_group_id          = aws_security_group.instance_Instance3_group.id
  description                       = "Allow from instance_Instance3_group (tcp:2049-2049)"
  from_port                         = 2049
  protocol                          = "tcp"
  to_port                           = 2049
  type                              = "ingress"
}

resource "aws_cloudfront_distribution" "CDN6" {
  aliases                           = ["wp.Zone1"]
  enabled                           = true
  http_version                      = "http2and3"
  is_ipv6_enabled                   = true
  price_class                       = "PriceClass_All"
  default_cache_behavior {
    response_headers_policy_id      = data.aws_cloudfront_response_headers_policy.policy_simplecors.id
    target_origin_id                = "origin_WordPress5"
    allowed_methods                 = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods                  = ["GET", "HEAD", "OPTIONS"]
    compress                        = true
    default_ttl                     = 0
    max_ttl                         = 0
    min_ttl                         = 0
    viewer_protocol_policy          = "redirect-to-https"
    forwarded_values {
      headers                       = ["Host", "Origin", "X-Forwarded-Proto", "X-Forwarded-For", "X-Forwarded-Host", "CloudFront-Forwarded-Proto"]
      query_string                  = true
      cookies {
        forward                     = "all"
      }
    }
  }
  ordered_cache_behavior {
    cache_policy_id                 = data.aws_cloudfront_cache_policy.policy_cachingoptimized.id
    target_origin_id                = "origin_StaticContentOffLoad5"
    allowed_methods                 = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods                  = ["GET", "HEAD", "OPTIONS"]
    path_pattern                    = "/wp-content/uploads/*"
    viewer_protocol_policy          = "redirect-to-https"
  }
  origin {
    domain_name                     = aws_s3_bucket.s3-off-load-wp-abcd5.bucket_regional_domain_name
    origin_access_control_id        = aws_cloudfront_origin_access_control.oac_s3-off-load-wp-abcd5.id
    origin_id                       = "origin_StaticContentOffLoad5"
  }
  origin {
    domain_name                     = aws_instance.Instance3.public_dns
    origin_id                       = "origin_WordPress5"
    custom_origin_config {
      http_port                     = 80
      https_port                    = 443
      origin_protocol_policy        = "http-only"
      origin_ssl_protocols          = ["TLSv1.2"]
    }
  }
  restrictions {
    geo_restriction {
      restriction_type              = "none"
    }
  }
  tags                              = {
    "Name" = "CDN6"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
  viewer_certificate {
    acm_certificate_arn             = aws_acm_certificate.Certificate1.arn
    cloudfront_default_certificate  = false
    minimum_protocol_version        = "TLSv1.2_2021"
    ssl_support_method              = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "oac_s3-off-load-wp-abcd5" {
  name                              = "oac-s3-off-load-wp-abcd5"
  description                       = "OAC for s3-off-load-wp-abcd5"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}




### CATEGORY: STORAGE ###

resource "aws_s3_bucket" "s3-off-load-wp-abcd5" {
  bucket                            = "s3-off-load-wp-abcd5"
  force_destroy                     = true
  object_lock_enabled               = false
  tags                              = {
    "Name" = "s3-off-load-wp-abcd5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_s3_bucket" "wp-script-cloudman2" {
  bucket                            = "wp-script-cloudman2"
  force_destroy                     = true
  object_lock_enabled               = false
  tags                              = {
    "Name" = "wp-script-cloudman2"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-off-load-wp-abcd5_controls" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd5.id
  rule {
    object_ownership                = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_ownership_controls" "wp-script-cloudman2_controls" {
  bucket                            = aws_s3_bucket.wp-script-cloudman2.id
  rule {
    object_ownership                = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "aws_s3_bucket_policy_s3-off-load-wp-abcd5_st_State6_doc" {
  statement {
    sid                             = "AllowCloudFrontServicePrincipalReadOnly"
    effect                          = "Allow"
    principals {
      identifiers                   = ["cloudfront.amazonaws.com"]
      type                          = "Service"
    }
    actions                         = ["s3:GetObject"]
    resources                       = ["${aws_s3_bucket.s3-off-load-wp-abcd5.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.CDN6.id}"]
    }
  }
}

resource "aws_s3_bucket_policy" "aws_s3_bucket_policy_s3-off-load-wp-abcd5_st_State6" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd5.id
  policy                            = data.aws_iam_policy_document.aws_s3_bucket_policy_s3-off-load-wp-abcd5_st_State6_doc.json
}

resource "aws_s3_bucket_public_access_block" "s3-off-load-wp-abcd5_block" {
  block_public_acls                 = true
  block_public_policy               = true
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd5.id
  ignore_public_acls                = true
  restrict_public_buckets           = true
}

resource "aws_s3_bucket_public_access_block" "wp-script-cloudman2_block" {
  block_public_acls                 = true
  block_public_policy               = true
  bucket                            = aws_s3_bucket.wp-script-cloudman2.id
  ignore_public_acls                = true
  restrict_public_buckets           = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-off-load-wp-abcd5_configuration" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd5.id
  expected_bucket_owner             = data.aws_caller_identity.current.account_id
  rule {
    bucket_key_enabled              = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "wp-script-cloudman2_configuration" {
  bucket                            = aws_s3_bucket.wp-script-cloudman2.id
  expected_bucket_owner             = data.aws_caller_identity.current.account_id
  rule {
    bucket_key_enabled              = true
  }
}

resource "aws_s3_bucket_versioning" "s3-off-load-wp-abcd5_versioning" {
  bucket                            = aws_s3_bucket.s3-off-load-wp-abcd5.id
  versioning_configuration {
    mfa_delete                      = "Disabled"
    status                          = "Suspended"
  }
}

resource "aws_s3_bucket_versioning" "wp-script-cloudman2_versioning" {
  bucket                            = aws_s3_bucket.wp-script-cloudman2.id
  versioning_configuration {
    mfa_delete                      = "Disabled"
    status                          = "Suspended"
  }
}

resource "aws_s3_object" "WordPressProfessional2" {
  source                            = "${path.module}/.external_modules/STRUCT8_Templates/EC2/Scripts/WordPress/WordPressProfessional.sh"
  bucket                            = aws_s3_bucket.wp-script-cloudman2.bucket
  checksum_algorithm                = "CRC32"
  content_type                      = "application/x-sh"
  etag                              = filemd5("${path.module}/.external_modules/STRUCT8_Templates/EC2/Scripts/WordPress/WordPressProfessional.sh")
  key                               = "WordPressProfessional.sh"
  tags                              = {
    "Name" = "WordPressProfessional2"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_db_instance" "database6" {
  db_name                           = "wordpress"
  db_subnet_group_name              = aws_db_subnet_group.subnet_group_database6.name
  allocated_storage                 = 20
  availability_zone                 = aws_subnet.DB_a5.availability_zone
  backup_retention_period           = 0
  copy_tags_to_snapshot             = true
  delete_automated_backups          = false
  engine                            = "mysql"
  engine_version                    = "8.0"
  iam_database_authentication_enabled = true
  identifier                        = "database6"
  instance_class                    = "db.t3.micro"
  manage_master_user_password       = true
  max_allocated_storage             = 100
  storage_encrypted                 = true
  storage_type                      = "gp3"
  upgrade_storage_config            = false
  username                          = "admin"
  vpc_security_group_ids            = [aws_security_group.db_instance_database6_group.id]
  tags                              = {
    "Name" = "database6"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_db_subnet_group" "subnet_group_database6" {
  name                              = "database6-subnet-group"
  subnet_ids                        = [aws_subnet.DB_b5.id, aws_subnet.DB_a5.id]
  tags                              = {
    "Name" = "subnet_group_database6"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_access_point" "AP5" {
  file_system_id                    = aws_efs_file_system.EFS5.id
  posix_user {
    gid                             = 48
    uid                             = 48
  }
  root_directory {
    path                            = "/wordpress"
    creation_info {
      owner_gid                     = 48
      owner_uid                     = 48
      permissions                   = "0755"
    }
  }
  tags                              = {
    "Name" = "AP5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_file_system" "EFS5" {
  encrypted                         = true
  throughput_mode                   = "elastic"
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  protection {
    replication_overwrite           = "ENABLED"
  }
  tags                              = {
    "Name" = "EFS5"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
}

resource "aws_efs_mount_target" "mt_EFS5_EFS_a5" {
  file_system_id                    = aws_efs_file_system.EFS5.id
  subnet_id                         = aws_subnet.EFS_a5.id
  security_groups                   = [aws_security_group.efs_file_system_EFS5_group.id]
}

resource "aws_efs_mount_target" "mt_EFS5_EFS_b5" {
  file_system_id                    = aws_efs_file_system.EFS5.id
  subnet_id                         = aws_subnet.EFS_b5.id
  security_groups                   = [aws_security_group.efs_file_system_EFS5_group.id]
}




### CATEGORY: COMPUTE ###

data "local_file" "UserData_Instance3" {
  filename                          = "${path.module}/.external_modules/STRUCT8_Templates/EC2/Scripts/WordPress/FetchAndRunS3Script.sh"
}

data "aws_ami" "AMI_Data_Source_Instance3" {
  most_recent                       = true
  owners                            = ["amazon"]
  filter {
    name                            = "name"
    values                          = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "Instance3" {
  subnet_id                         = aws_subnet.WP2.id
  ami                               = data.aws_ami.AMI_Data_Source_Instance3.id
  associate_public_ip_address       = true
  iam_instance_profile              = aws_iam_instance_profile.profile_Instance3.name
  instance_type                     = "t3.micro"
  user_data_base64                  = base64encode(<<-EOFUData
#!/bin/bash

# --- BEGIN STRUCT8 VARIABLES ---
cat << 'EOFENV' > /etc/struct8_env
AWS_S3_SCRIPT_KEY="WordPressProfessional.sh"
WPDOMAIN="wp.cloudman.pro"
ENABLE_PROXYSQL="false"
WP_VERSION="6.7"
PHP_VERSION="8.3"
NAME="Instance3"
REGION="${data.aws_region.current.name}"
ACCOUNT="${data.aws_caller_identity.current.account_id}"
AWS_S3_BUCKET_NAME_SCRIPT="wp-script-cloudman2"
AWS_EFS_ACCESS_POINT_ID_0="${aws_efs_access_point.AP5.id}"
AWS_DB_INSTANCE_ENDPOINT_DB="${aws_db_instance.database6.endpoint}"
AWS_DB_INSTANCE_DB_NAME_DB="${aws_db_instance.database6.db_name}"
AWS_DB_INSTANCE_USER_NAME_DB="${one(aws_db_instance.database6.master_user_secret[*].secret_arn)}:username::"
AWS_DB_INSTANCE_PASS_DB="${one(aws_db_instance.database6.master_user_secret[*].secret_arn)}:password::"
AWS_EFS_FILE_SYSTEM_ID_0="${aws_efs_file_system.EFS5.id}"
AWS_S3_BUCKET_NAME_OFF_LOAD="s3-off-load-wp-abcd5"
EOFENV
cat /etc/struct8_env >> /etc/environment
sed 's/^/export /' /etc/struct8_env > /etc/profile.d/struct8_vars.sh
chmod +x /etc/profile.d/struct8_vars.sh
chmod 644 /etc/struct8_env
# --- END STRUCT8 VARIABLES ---

${data.local_file.UserData_Instance3.content}
EOFUData
)
  user_data_replace_on_change       = false
  vpc_security_group_ids            = [aws_security_group.instance_Instance3_group.id]
  instance_market_options {
    market_type                     = "spot"
    spot_options {
      instance_interruption_behavior = "terminate"
      spot_instance_type            = "one-time"
    }
  }
  tags                              = {
    "Name" = "Instance3"
    "State" = "State6"
    "CloudmanUser" = "Ricardo"
  }
  depends_on                        = [aws_iam_role_policy_attachment.instance_Instance3_st_State6_attach]
}


