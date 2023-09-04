#--------modules inputs and usage for ECS, API-GATEWAY and COGNITO -----------
# --------Provider-Configuration------------
provider "aws" {
  region     = var.region
  access_key = "XXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXX"
}

module "part_1_outputs" {
  source                = "../part-1"
  region                = var.region
  vpc_cidr              = var.vpc_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  repo-name             = var.repo-name
  namespace-name        = var.namespace-name
  cloudmap-service-name = var.cloudmap-service-name
}

module "sleep-time" {
  source     = "../modules/local-exec"
  depends_on = [module.part_1_outputs]
}

module "prod-ecs" {
  source              = "../modules/ECS"
  cluster_name        = var.cluster-name
  task_name           = var.task-name
  execution_role_name = var.execution-role-name
  task_role_name      = var.task-role-name
  container_name      = var.container-name
  image               = module.part_1_outputs.image
  launch_type         = var.launch-type
  container_port      = var.container-port
  service_name        = var.service-name
  vpc-id              = module.part_1_outputs.vpc-id
  subnet1             = module.part_1_outputs.subnet-id1
  subnet2             = module.part_1_outputs.subnet-id2
  security-group      = module.part_1_outputs.security-gp-id
  registry-arn        = module.part_1_outputs.map-arn
  depends_on          = [module.sleep-time]

}

module "prod-apigateway" {
  source           = "../modules/API-GATEWAY"
  vpc-link-name    = var.vpc_link_name
  subnet1          = module.part_1_outputs.subnet-id1
  subnet2          = module.part_1_outputs.subnet-id2
  security-id      = module.part_1_outputs.security-gp-id
  api-name         = var.api_name
  protocol         = var.protocol-type
  integration-type = var.integration_type
  map-service-arn  = module.part_1_outputs.map-arn
  method           = var.method
  connection-type  = var.connection_type
  route-key        = var.route
  pool-id          = module.prod-cognito.user-pool-id
  client-id        = module.prod-cognito.client-id
  authorizer-type  = var.authorizer-type
  authorizer-name = var.authorizer-name
  depends_on       = [module.prod-ecs]
}

module "prod-cognito" {
  source                = "../modules/COGNITO"
  user-pool-name        = var.user_pool_name
  email-sending-account = var.email_sending_account
  attribute             = var.attribute
  domain                = var.domain
  client-name           = var.client_name
  callback-url          = module.prod-apigateway.api-url
  depends_on            = [module.prod-ecs]
}