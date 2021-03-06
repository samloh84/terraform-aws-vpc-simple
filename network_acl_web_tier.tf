// NOTE: Each VPC can contain up to 200 network ACLs and each network ACL can contain up to 20 ingress rules and 20 egress rules
// https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html

// https://www.terraform.io/docs/providers/aws/r/network_acl.html
resource "aws_network_acl" "web_tier" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.web_tier_ap-southeast-1a.id,
    aws_subnet.web_tier_ap-southeast-1b.id
  ]

  tags = {
    Name         = "${var.vpc_name}.network_acl.web_tier"
    Description  = "${var.vpc_name} web tier Network ACL"
    Owner        = var.vpc_owner
    Network_Tier = "web"
  }
}

locals {
  network_acl_web_https_ingress_from_cidr_blocks = flatten([
    var.remote_https_cidrs
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_https_ingress_from_cidr_blocks" {
  count          = length(local.network_acl_web_https_ingress_from_cidr_blocks)
  egress         = false
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  rule_number    = 100 + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_https_ingress_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_http_ingress_from_cidr_blocks = flatten([
    var.remote_https_cidrs
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_http_ingress_from_cidr_blocks" {
  count          = length(local.network_acl_web_http_ingress_from_cidr_blocks)
  egress         = false
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_ingress_from_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_http_ingress_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_all_ingress_from_cidr_blocks = flatten([
    list(local.web_tier_cidr_block)
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_all_ingress_from_cidr_blocks" {
  count          = length(local.network_acl_web_all_ingress_from_cidr_blocks)
  egress         = false
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_http_ingress_from_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_all_ingress_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_ssh_ingress_from_cidr_blocks = flatten([
    list(local.management_tier_cidr_block)
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_ssh_ingress_from_cidr_blocks" {
  count          = length(local.network_acl_web_ssh_ingress_from_cidr_blocks)
  egress         = false
  from_port      = 22
  to_port        = 22
  protocol       = "tcp"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_http_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_all_ingress_from_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_ssh_ingress_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_ephemeral_ingress_from_cidr_blocks = flatten([
    "0.0.0.0/0"
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_ephemeral_ingress_from_cidr_blocks" {
  count          = length(local.network_acl_web_ephemeral_ingress_from_cidr_blocks)
  egress         = false
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_http_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_all_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_ssh_ingress_from_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_ephemeral_ingress_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_all_ingress_to_nat_gateway_from_cidr_blocks = flatten([
    local.application_tier_cidr_block,
    local.database_tier_cidr_block
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_all_ingress_to_nat_gateway_from_cidr_blocks" {
  count          = length(local.network_acl_web_all_ingress_to_nat_gateway_from_cidr_blocks)
  egress         = false
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_http_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_all_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_ssh_ingress_from_cidr_blocks)) + (10 * length(local.network_acl_web_ephemeral_ingress_from_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_all_ingress_to_nat_gateway_from_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_https_egress_to_cidr_blocks = flatten([
    list(local.application_tier_cidr_block)
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_https_egress_to_cidr_blocks" {
  count          = length(local.network_acl_web_https_egress_to_cidr_blocks)
  egress         = true
  from_port      = 443
  to_port        = 443
  protocol       = "tcp"
  rule_number    = 100 + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_https_egress_to_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_http_egress_to_cidr_blocks = flatten([
    list(local.application_tier_cidr_block)
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_http_egress_to_cidr_blocks" {
  count          = length(local.network_acl_web_http_egress_to_cidr_blocks)
  egress         = true
  from_port      = 80
  to_port        = 80
  protocol       = "tcp"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_egress_to_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_http_egress_to_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_all_egress_to_cidr_blocks = flatten([
    "0.0.0.0/0",
    list(local.web_tier_cidr_block)
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_all_egress_to_cidr_blocks" {
  count          = length(local.network_acl_web_all_egress_to_cidr_blocks)
  egress         = true
  from_port      = 0
  to_port        = 0
  protocol       = "-1"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_egress_to_cidr_blocks)) + (10 * length(local.network_acl_web_http_egress_to_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_all_egress_to_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}


locals {
  network_acl_web_ephemeral_egress_to_cidr_blocks = flatten([
    "0.0.0.0/0"
  ])
}

// https://www.terraform.io/docs/providers/aws/r/network_acl_rule.html
resource "aws_network_acl_rule" "web_ephemeral_egress_to_cidr_blocks" {
  count          = length(local.network_acl_web_ephemeral_egress_to_cidr_blocks)
  egress         = true
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  rule_number    = 100 + (10 * length(local.network_acl_web_https_egress_to_cidr_blocks)) + (10 * length(local.network_acl_web_http_egress_to_cidr_blocks)) + (10 * length(local.network_acl_web_all_egress_to_cidr_blocks)) + (10 * count.index)
  rule_action    = "allow"
  cidr_block     = local.network_acl_web_ephemeral_egress_to_cidr_blocks[count.index]
  network_acl_id = aws_network_acl.web_tier.id
}

