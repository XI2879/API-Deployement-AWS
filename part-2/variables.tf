#----------Inputs for VPC , ECR & CloudMap------
variable "region" {
  description = "AWS Region"
  default     = "ap-south-1"

}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.1.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.2.0/24"
}

variable "repo-name" {
  description = "name of the repository"
  default     = "demo"
}

variable "namespace-name" {
  description = "name of the namespace in cloudmap"
  default     = "microserviceslocal"
}

variable "cloudmap-service-name" {
  description = "name of the cloudmap service "
  default     = "cloudmap_service"
}

#--------Inputs for ECS module----------

variable "cluster-name" {
  description = "name of the ecs cluster"
  default     = "fargate-cluster"
}
variable "task-name" {
  description = "name of the task definition"
  default     = "fargate-task"
}
variable "execution-role-name" {
  description = "name of the execution role"
  default     = "ecsExecutionRole"
}
variable "task-role-name" {
  description = "name of the task role"
  default     = "ecsTaskRole"
}
variable "container-name" {
  description = "name of the container"
  default     = "ECS-Container"
}
variable "launch-type" {
  description = "select launch type while creating task definition "
  default     = "FARGATE"
}
variable "container-port" {
  description = "container port on which application is running"
  default     = 80
}
variable "service-name" {
  description = "service name in a cluster"
  default     = "fargate-service"
}

#---------Inputs for API-GATEWAY module------
variable "vpc_link_name" {
  description = "name of the vpc link "
  default     = "prodvpclink"
}
variable "api_name" {
  description = "name of the http api"
  default     = "prod-api"
}
variable "protocol-type" {
  description = "API protocol"
  default     = "HTTP"
}
variable "integration_type" {
  description = "Integration type of an integration"
  default     = "HTTP_PROXY"
}
variable "method" {
  description = "Integrations ANY GET PUT method"
  default     = "ANY"
}
variable "connection_type" {
  description = "Type of the network connection to the integration endpoint"
  default     = "VPC_LINK"
}
variable "route" {
  description = "Route key for the route,combination of an HTTP method and resource path"
  default     = "ANY /"
}
variable "authorizer-type" {
  description = "HTTP APIs, specify JWT to use JSON Web Tokens"
  default     = "JWT"
}
variable "authorizer-name" {
  description = "name of the authorizer"
  default = "JWT-authorizer"
}
#---------Inputs for COGNITO module----
variable "user_pool_name" {
  description = "Name of the user pool"
  default     = "myuserspool"
}
variable "email_sending_account" {
  description = "sending email with cognito"
  default     = "COGNITO_DEFAULT"
}
variable "attribute" {
  description = "email addresses or phone numbers can be specified as usernames when a user signs up.Attributes to be auto-verified"
  default     = "email"
}
variable "domain" {
  description = "Amazon Cognito prefix domains, this is the prefix alone."
  default     = "prod-pyapp"
}
variable "client_name" {
  description = "name of the client"
  default     = "webclients"
}