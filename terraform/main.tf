resource "aws_ecs_cluster" "main" {
  name = "hello-world-app"
}

resource "aws_ecs_task_definition" "hello_world" {
  family                   = "hello-world-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "urssaibalaji/hello-world-nodejs:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

  execution_role_arn = "arn:aws:iam::891376961949:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::891376961949:role/ecsTaskExecutionRole"
}

resource "aws_ecs_service" "hello_world" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets         = ["subnet-0d32508389535e712", "subnet-0f380a26b9b500d76"]
    security_groups = ["sg-019423dc02284f052"]
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.hello_world.arn
    container_name   = "hello-world"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.hello_world]
}


resource "aws_lb" "hello_world" {
  name               = "hello-world-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-019423dc02284f052"]
  subnets            = ["subnet-0d32508389535e712", "subnet-0f380a26b9b500d76"]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "hello_world" {
  name     = "hello-world-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "vpc-0239559029a1d22b7"
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "hello_world" {
  load_balancer_arn = aws_lb.hello_world.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hello_world.arn
  }
}
