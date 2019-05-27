

variable "vpc_cidr_block" {
    type = "string"
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    type = "string"
}

variable "vpc_owner" {
    type = "string"
}

variable "remote_management_cidrs" {
    type = "list"
}