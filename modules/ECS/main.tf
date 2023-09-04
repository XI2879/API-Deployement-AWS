#-------creating ECS cluster,Task definition and ECS-Service---------
resource "aws_ecs_cluster" "aws_fargate_cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "execution_role" {
  name = var.execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess",
  "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
  "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]

}
resource "aws_iam_role" "task_role" {
  name = var.task_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]

}


resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.task_name
  network_mode             = "awsvpc"
  requires_compatibilities = [var.launch_type]
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  depends_on = [
    aws_ecs_task_definition.ecs_task_definition,

  ]
  name            = var.service_name
  cluster         = aws_ecs_cluster.aws_fargate_cluster.id
  launch_type     = var.launch_type
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  network_configuration {
    subnets         = ["${var.subnet1}", "${var.subnet2}"]
    security_groups = [var.security-group]
  }
  service_registries {
    registry_arn = var.registry-arn
    port         = var.container_port
  }
}