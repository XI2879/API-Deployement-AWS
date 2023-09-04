output "image" {
    value = "${module.prod-ecr.ecr_repository_url}:latest"
}
output "vpc-id" {
    value = module.prod-vpc.vpc_id
}
output "subnet-id1" {
    value = module.prod-vpc.subnet-id1
}
output "subnet-id2" {
    value = module.prod-vpc.subnet-id2
}
output "security-gp-id" {
    value = module.prod-vpc.security-gp-id
}
output "map-arn" {
    value = module.prod-cloudmap.service-arn
}