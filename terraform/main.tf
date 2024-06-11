resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "task" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "hello-world-container"
      image     = "your-dockerhub-username/hello-world-nodejs:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets         = ["subnet-0d32508389535e712", "subnet-0f380a26b9b500d76"]
    security_groups = ["sg-019423dc02284f052"]
  }
}
