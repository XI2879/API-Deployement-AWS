output "vpc_id" {
  value = aws_vpc.production-vpc.id
}
output "subnet-id1" {
  value = aws_subnet.private-subnet-1.id
}
output "subnet-id2" {
  value = aws_subnet.private-subnet-2.id
}
output "security-gp-id" {
  value = aws_security_group.cloudmap_sg.id
}