data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/dev/app/db_host"
  type  = "String"
  value = module.rds.db_endpoint_mysql
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/dev/app/db_user"
  type  = "SecureString"
  value = var.db_user
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/dev/app/db_password"
  type  = "SecureString"
  value = var.db_password
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
  #bucket_name = var.bucket_name
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


  container_image = var.container_image
  container_port  = var.container_port

  cluster_id = module.ecs_cluster.cluster_id
  #sg_tasks   = module.security.sg_tasks
  #sg_alb     = module.security.sg_alb
  sg_tasks   = module.security.sg_mysql_default
  sg_alb     = module.security.sg_mysql_default
  

  #db_host    = module.rds.db_endpoint_mysql
  db_host     = module.rds.db_endpoint_mysql
  db_user     = var.db_user
  db_name     = var.db_name
  db_password = var.db_password


}


module "ecs_iam" {
  source = "./ecs-iam"

  name_prefix = "backend"

  region     = var.region
  account_id = data.aws_caller_identity.current.account_id

  ssm_parameters_arns = [
    aws_ssm_parameter.db_host.arn,
    aws_ssm_parameter.db_user.arn,
    aws_ssm_parameter.db_password.arn
  ]
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



module "cloudfront" {
  source = "./cloudfront"

  name                           = "devsu-app"
  s3_bucket_id                   = module.s3.bucket_name
  s3_bucket_arn                  = module.s3.bucket_arn
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  s3_bucket_website_endpoint     = module.s3.website_url


  # No aliases by default - if you want to use a custom domain, create/validate an ACM certificate
  aliases = []

  # ACM certificate ARN (must be in us-east-1) - set to empty string to use CloudFront default cert
  acm_certificate_arn = ""
  depends_on = [ module.s3 ]
}
