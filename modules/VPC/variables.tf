variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 1"
}
variable "aws_region" {
  default = "ap-south-1"
}