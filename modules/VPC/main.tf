#-----VPC with two private subnets and vpc endpoints----
resource "aws_vpc" "production-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Production-VPC"
  }
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block              = var.private_subnet_1_cidr
  vpc_id                  = aws_vpc.production-vpc.id
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block              = var.private_subnet_2_cidr
  vpc_id                  = aws_vpc.production-vpc.id
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-Subnet-2"
  }
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.production-vpc.id
  tags = {
    Name = "Private-Route-Table"
  }
}


resource "aws_route_table_association" "private-subnet-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_security_group" "cloudmap_sg" {
  name   = "CloudMapSG"
  vpc_id = aws_vpc.production-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "-1"
    from_port   = 0 #all protocols
    to_port     = 0
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
  depends_on = [
    aws_vpc.production-vpc,
    aws_subnet.private-subnet-1,
    aws_subnet.private-subnet-2,
    aws_route_table.private-route-table,
    aws_route_table_association.private-subnet-1-association,
    aws_route_table_association.private-subnet-2-association,
    aws_security_group.cloudmap_sg,

  ]
  vpc_id              = aws_vpc.production-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.cloudmap_sg.id]
  subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}

resource "aws_vpc_endpoint" "ecr_api_endpoint" {
  depends_on = [
    aws_vpc.production-vpc,
    aws_subnet.private-subnet-1,
    aws_subnet.private-subnet-2,
    aws_route_table.private-route-table,
    aws_route_table_association.private-subnet-1-association,
    aws_route_table_association.private-subnet-2-association,
    aws_security_group.cloudmap_sg,

  ]
  vpc_id              = aws_vpc.production-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.cloudmap_sg.id]
  subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}

resource "aws_vpc_endpoint" "cwlogs_endponit" {
  depends_on = [
    aws_vpc.production-vpc,
    aws_subnet.private-subnet-1,
    aws_subnet.private-subnet-2,
    aws_route_table.private-route-table,
    aws_route_table_association.private-subnet-1-association,
    aws_route_table_association.private-subnet-2-association,
    aws_security_group.cloudmap_sg,

  ]
  vpc_id              = aws_vpc.production-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.cloudmap_sg.id]
  subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  depends_on = [
    aws_vpc.production-vpc,
    aws_subnet.private-subnet-1,
    aws_subnet.private-subnet-2,
    aws_route_table.private-route-table,
    aws_route_table_association.private-subnet-1-association,
    aws_route_table_association.private-subnet-2-association,
    aws_security_group.cloudmap_sg,

  ]
  vpc_id              = aws_vpc.production-vpc.id
  service_name        = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type   = "Gateway"
}
resource "aws_vpc_endpoint_route_table_association" "s3_association" {
  route_table_id  = aws_route_table.private-route-table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}




