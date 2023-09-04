resource "aws_ecr_repository" "example_repo" {
  name                 = var.repo_name
  image_tag_mutability = "IMMUTABLE"
}