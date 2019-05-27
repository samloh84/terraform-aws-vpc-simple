# Terraform AWS VPC - Simple

Terraform module for creating a simple VPC on AWS.

## Usage

```hcl-terraform
module "vpc-simple" {
  source = "git::https://github.com/samloh84/terraform-aws-vpc-simple.git"
  vpc_cidr_block = "10.0.0.0/16"
  remote_management_cidrs = ["0.0.0.0/0"] 
  vpc_name = "vpc-simple"
  vpc_owner = "Samuel"
}
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
