resource "aws_service_discovery_private_dns_namespace" "my_namespace" {
  name = var.namespace
  vpc  = var.vpc-id
}
resource "aws_service_discovery_service" "my_service" {
  name = var.service

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.my_namespace.id

    dns_records {
      ttl  = 60
      type = "SRV"

    }

    routing_policy = "MULTIVALUE"
  }
}