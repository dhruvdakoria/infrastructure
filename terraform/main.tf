# Base Infrastructure module to create VPC, ALBs, Cloudfront, SGs, ECR, ECS
module "base-infra" {
  source = "./base-infra"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  ecs_key_pair_name=var.key_pair_name
  acm_certificate_arn="arn:aws:acm:us-east-1:444716747145:certificate/192d9549-929f-44f6-911c-19bb4c3ace4b"
  r53_domain_name="dhruv-toptal-project.cf"
  r53_hosted_zone_id="Z01341672GWBA3T2L5CX8"
}

# Web Service Deployment
module "web-service" {
  source = "./ecs-services/web-service"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  aws_ecs_cluster_main_arn = module.base-infra.aws_ecs_cluster_main_arn
  aws_lb_target_group_web_arn = module.base-infra.aws_lb_target_group_web_arn
  aws_iam_role_execution_role_arn = module.base-infra.aws_iam_role_execution_role_arn
  aws_iam_role_task_role_arn = module.base-infra.aws_iam_role_task_role_arn
  aws_lb_api_dns_name = module.base-infra.aws_lb_api_dns_name
  aws_account_id= var.aws_account_id
  depends_on = [module.base-infra]
  
}

# Monitoring Service Deployment
module "monitoring-service" {
  source = "./ecs-services/monitoring-service"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  aws_ecs_cluster_main_arn = module.base-infra.aws_ecs_cluster_monitoring_arn
  aws_lb_target_group_monitoring_arn = module.base-infra.aws_lb_target_group_monitoring_arn
  aws_iam_role_execution_role_arn = module.base-infra.aws_iam_role_execution_role_arn
  aws_iam_role_task_role_arn = module.base-infra.aws_iam_role_task_role_arn
  aws_lb_api_dns_name = module.base-infra.aws_lb_api_dns_name
  aws_account_id= var.aws_account_id
  depends_on = [module.base-infra]
  
}

#API Service Deployment
module "api-service" {
  source = "./ecs-services/api-service"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  aws_ecs_cluster_main_arn = module.base-infra.aws_ecs_cluster_main_arn
  aws_lb_target_group_api_arn = module.base-infra.aws_lb_target_group_api_arn
  aws_iam_role_execution_role_arn = module.base-infra.aws_iam_role_execution_role_arn
  aws_iam_role_task_role_arn = module.base-infra.aws_iam_role_task_role_arn
  aws_account_id= var.aws_account_id
  database_url= module.database.db_url
  database_name = var.database_name 
  database_username = var.database_username
  database_password = var.database_password
  database_port     = var.database_port
  depends_on = [module.base-infra]
}

# Postgres Database on port 5432
module "database" {
  source  = "./db"
  name = "${var.project_identifier}-${var.stage}"
  vpc_id = module.base-infra.aws_vpc_main_id
  database_identifier = "${var.project_identifier}-${var.stage}-postgres"
  engine_version    = "9.6"
  instance_type     = "db.t2.micro"
  storage_type     = "gp2"
  allocated_storage = 10
  storage_encrypted = false
  database_name = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  database_port     = var.database_port
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = 7
  snapshot_identifier = "toptal-snapshot"
  aws_subnet_private_1_id = module.base-infra.aws_subnet_private_1_id
  aws_subnet_private_2_id = module.base-infra.aws_subnet_private_2_id
  aws_subnet_private_3_id = module.base-infra.aws_subnet_private_3_id
  depends_on = [module.base-infra]
}

#CI/CD Pipeline Deployment - Web Service
module "cicd_web" {
  source = "./cicd"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  tier = "web"
  cluster = "ecs-cluster"
  aws_account_id=var.aws_account_id
  github_token = var.github_token
  github_owner = var.github_owner
  github_repo = "dhruv-toptal-web"
  github_branch = var.github_branch
  depends_on = [module.web-service]
}

#CI/CD Pipeline Deployment - API Service
module "cicd_api" {
  source = "./cicd"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  tier = "api"
  cluster = "ecs-cluster"
  aws_account_id=var.aws_account_id
  github_token = var.github_token
  github_owner = var.github_owner
  github_repo = "dhruv-toptal-api"
  github_branch = var.github_branch
  depends_on = [module.api-service]
}

#CI/CD Pipeline Deployment - Monitoring
module "cicd_monitoring" {
  source = "./cicd"
  name = "${var.project_identifier}-${var.stage}"
  region = var.region
  tier = "monitoring"
  cluster = "ecs-cluster-monitoring"
  aws_account_id=var.aws_account_id
  github_token = var.github_token
  github_owner = var.github_owner
  github_repo = "dhruv-toptal-monitoring"
  github_branch = var.github_branch
  depends_on = [module.monitoring-service]
}