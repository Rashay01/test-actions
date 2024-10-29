provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

resource "aws_ecs_cluster" "this" {
  name = "my-react-app-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "my-react-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  container_definitions   = jsonencode([
    {
      name      = "my-react-app"
      image     = "YOUR_ECR_IMAGE_URI" # Replace with ECR image URI
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "my-react-app-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["YOUR_SUBNET_ID"]  # Replace with your subnet IDs
    security_groups  = ["YOUR_SECURITY_GROUP_ID"]  # Replace with your security group ID
    assign_public_ip = true
  }
}
