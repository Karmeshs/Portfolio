resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
  tags = merge(var.default_tags, tomap({ "Name" = var.ecr_name }))
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "delete images other than latest 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}