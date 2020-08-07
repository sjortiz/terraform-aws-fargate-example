terraform {
      backend "remote" {
        organization = "stashconsulting"

        workspaces {
            name = "api"
        }
    }
}

provider aws {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "super_cool_cluster" {
  name = "super-cool-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

resource "aws_ecs_task_definition" "api_task" {
  container_definitions = templatefile(
    "task_definitions/service.tmpl",
    {
      DockerImage = var.DockerImage,
      Port        = var.Port
    }
  )
  cpu                      = 256
  family                   = "backend_api"
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "api_service" {
  name            = "backend_api"
  cluster         = aws_ecs_cluster.super_cool_cluster.arn
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 1
  network_configuration {
    assign_public_ip = true
    security_groups  = ["sg-035ab2b542979b957"]
    subnets = [
      "subnet-052f463b",
      "subnet-bf613bd8"
    ]
  }
  launch_type = "FARGATE"
}
