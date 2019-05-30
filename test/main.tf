module "vpc-simple" {
  source = "../"

  remote_management_cidrs = ["0.0.0.0/0"]
  vpc_name = "samuel-vpc-simple"
  vpc_owner = "Samuel"
  vpc_cidr_block = "10.0.0.0/16"
}
