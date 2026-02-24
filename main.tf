########################################
# TERRAFORM CONFIG
########################################
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "aleem-terraform-state-253339176093-us-east-1"
    key            = "ecs-nodejs-mongodb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

########################################
# PROVIDER
########################################
provider "aws" {
  region = var.region
}

########################################
# ECR Repository
########################################
resource "aws_ecr_repository" "app" {
  name = var.project_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

########################################
# VPC MODULE
########################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.project_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true
}

########################################
# ALB MODULE
########################################
module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  project_name      = var.project_name
}

########################################
# ECS SECURITY GROUP
########################################
resource "aws_security_group" "ecs_tasks" {
  name   = "${var.project_name}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# SECRETS MANAGER (Mongo URI)
########################################
resource "aws_secretsmanager_secret" "mongo" {
  name = "${var.project_name}-mongo-uri"
}

resource "aws_secretsmanager_secret_version" "mongo" {
  secret_id     = aws_secretsmanager_secret.mongo.id
  secret_string = var.mongo_uri
}

########################################
# ECS MODULE
########################################
module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  region       = var.region

  ################################
  # IMAGE SETTINGS
  ################################
  ecr_repository_url = aws_ecr_repository.app.repository_url
  image_tag          = var.image_tag

  ################################
  # SECRET
  ################################
  mongo_secret_arn = aws_secretsmanager_secret.mongo.arn

  ################################
  # NETWORK
  ################################
  public_subnet_ids     = module.vpc.public_subnets
  ecs_security_group_id = aws_security_group.ecs_tasks.id
  alb_target_group_arn  = module.alb.target_group_arn

  ################################
  # ECS SETTINGS
  ################################
  desired_count = var.desired_count
  task_cpu      = var.task_cpu
  task_memory   = var.task_memory

  ################################
  # CONTAINER ENV
  ################################
  container_environment = [
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "NODE_ENV"
      value = var.environment
    }
  ]
}
