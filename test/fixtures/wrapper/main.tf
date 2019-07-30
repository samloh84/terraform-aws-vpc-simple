module "vpc-simple" {
  source = "../../../"

  vpc_name = "samuel-vpc-simple"
  vpc_owner = "Samuel"
  vpc_cidr_block = "10.0.0.0/16"
  remote_management_cidrs = [data.external.local_ip.result.ip]
  remote_https_cidrs =  [data.external.local_ip.result.ip]
}
