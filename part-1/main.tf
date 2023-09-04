#--------modules inputs and usage for VPC, ECR and CLOUDMAP -----------
#--------Provider-Configuration------------
# provider "aws" {
#   region     = var.region
#   access_key = "AKIAQTWECCHN3HVBHPFI"
#   secret_key = "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"
# }



module "prod-vpc" {
  source                = "../modules/VPC"
  vpc_cidr              = var.vpc_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

module "prod-ecr" {
  source    = "../modules/ECR"
  repo_name = var.repo-name
}

module "prod-cloudmap" {
  source    = "../modules/CLOUDMAP"
  namespace = var.namespace-name
  service   = var.cloudmap-service-name
  vpc-id    = module.prod-vpc.vpc_id

}