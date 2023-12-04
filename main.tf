# Create an ECS cluster
resource "aws_ecs_cluster" "ecom_app_ecs_cluster" {
  name = "ecom-app-ecs-cluster"
}

# Create a task definition for the ECS service
resource "aws_ecs_task_definition" "ecom_app_task_definition" {
  family                   = "ecom-app-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS FARGATE
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-container",
      "image": "nginx", 
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

# Create an ECS service
resource "aws_ecs_service" "ecs_service" {
  name            = "ecom-app-ecs-service"
  cluster         = aws_ecs_cluster.ecom_app_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecom_app_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.ecom_app_vpc.public_subnets
    security_groups  = [aws_security_group.ecom_app_ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = module.ecom_app_alb.target_group_arns[0]
    container_name   = "my-container"
    container_port   = 80
  }
}

resource "aws_s3_bucket" "ecom_bucket" {
  bucket = "ecom-bucket.sanmi-project.com"
}

module "mysql_db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "sanmiecomedb"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.m5d.large"
  allocated_storage = 5

  db_name  = "sanmiecomdb"
  username = "user"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.ecom_app_db_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  multi_az           = true

  # Enhanced Monitoring role
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.ecom_app_vpc.private_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}
