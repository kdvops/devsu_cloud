terraform {
#  required_version = ">= 1.4"
  required_version = ">= 1.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.23.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}



data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



######### VPC   #########
module "vpc" {
  source = "./vpc"
}


#########    IAM ROLES FOR ECS   #########
module "iam" {
  source = "./iam"
}

#########    S3    #########
module "s3" {
  source = "./s3"
}

######### SECURITY GROUPS FOR ALB + ECS   #########
module "security" {
  source      = "./security"
  #vpc_id     = module.vpc.vpc_id
  vpc_id2     = data.aws_vpc.default.id
  vpc_id      = data.aws_vpc.default.id
  
}

########   ECS CLUSTER   #######
module "ecs_cluster" {
  source = "./ecs_cluster"
}

#######   ECS FARGATE SERVICE   #######
module "ecs" {
  source = "./ecs"

  #vpc_id          = module.vpc.vpc_id
  #private_subnets = module.vpc.private_subnets
  #public_subnets  = module.vpc.public_subnets
  vpc_id           = data.aws_vpc.default.id
  private_subnets = data.aws_subnets.default.ids
  public_subnets  = data.aws_subnets.default.ids

  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn

  container_image = var.container_image
  container_port  = var.container_port

  cluster_id = module.ecs_cluster.cluster_id
  #sg_tasks   = module.security.sg_tasks
  #sg_alb     = module.security.sg_alb
  sg_tasks   = module.security.sg_mysql_default
  sg_alb     = module.security.sg_mysql_default
  

  #db_host     = module.rds.db_endpoint_mysql
  db_host     = var.db_host
  db_user     = var.db_user
  db_name     = "testdb"
  db_password = var.db_password

}

###########     RDS MySQL    #################
module "rds" {
  source      = "./rds"
  #vpc_id      = module.vpc.vpc_id
  #subnet_ids  = module.vpc.private_subnets
  #subnet_ids = module.vpc.public_subnets
  
  vpc_id      = data.aws_vpc.default.id
  subnet_ids  = data.aws_subnets.default.ids
  db_user     = var.db_user
  db_password = var.db_password
  #db_sg_id    = module.security.sg_db
  db_sg_id    = module.security.sg_mysql_default

}
