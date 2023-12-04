# Create a security group for the ECS tasks
resource "aws_security_group" "ecom_app_ecs_sg" {
  name        = "ecs-security-group"
  description = "Security group for ECS tasks"
  vpc_id      = module.ecom_app_vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecom_alb_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create a security group for the RDS DB
resource "aws_security_group" "ecom_app_db_sg" {
  name        = "db-security-group"
  description = "Security group for RDS DB"
  vpc_id      = module.ecom_app_vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecom_app_ecs_sg.id]
  }
}
# create security group for alb
resource "aws_security_group" "ecom_alb_sg" {
  name        = "ecom-alb-sg"
  description = "Security group for ALB"
  vpc_id      = module.ecom_app_vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create alb for traffic
module "ecom_app_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "ecom-app-alb"

  load_balancer_type = "application"

  vpc_id          = module.ecom_app_vpc.vpc_id
  subnets         = module.ecom_app_vpc.public_subnets
  security_groups = [aws_security_group.ecom_alb_sg.id]

  target_groups = [
    {
      name_prefix      = "app-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags = {
    Terraform = "true"
  }
}