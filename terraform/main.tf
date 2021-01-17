############################################
###### base_infra module to start: #####
######                                 ##### 
######  VPC, ECS, LC, ALB, ASG, LC     #####
############################################


module "base-infra" {
  source = "./base-infra"
  name = "${var.project_identifier}-${var.stage}"
  region = "${var.region}"
  aws_security_group_monitoring_vm_id = module.monitoring.aws_security_group_monitoring_vm_id
  ecs_key_pair_name="${var.key_pair_name}"
}

######################
##### Monitoring #####
######################


module "monitoring" {
 source = "./monitoring"
 aws_iam_role_execution_role_arn = module.base_infra.aws_iam_role_execution_role_arn
 aws_iam_role_task_role_arn = module.base_infra.aws_iam_role_task_role_arn
 aws_ecs_cluster_main_arn = module.base_infra.aws_ecs_cluster_main_arn
 aws_subnet_public_id = module.base_infra.aws_subnet_public_id
 vpc_id = module.base_infra.aws_vpc_main_id
 aws_security_group_ecs_id = module.base_infra.aws_security_group_ecs_id
 ecs_key_pair_name="${var.key_pair_name}"
}


#################################
### Front end service module ####
#################################

module "web-service" {
  source = "./web-service"
  name = "${var.project_identifier}-${var.stage}"
  region = "${var.region}"
  aws_ecs_cluster_main_arn = module.base_infra.aws_ecs_cluster_main_arn
  aws_lb_target_group_web_arn = module.base_infra.aws_lb_target_group_web_arn
  aws_iam_role_execution_role_arn = module.base_infra.aws_iam_role_execution_role_arn
  aws_iam_role_task_role_arn = module.base_infra.aws_iam_role_task_role_arn
  aws_lb_api_dns_name = module.base_infra.aws_lb_api_dns_name
  loki_ip = module.monitoring.ec2_private_ip
  aws_account_id= "${var.aws_account_id}"
  depends_on = [module.base_infra]
  
}

#############################
### API service module   ####
#############################

module "api-service" {
  source = "./api-service"
  name = "${var.project_identifier}-${var.stage}"
  region = "${var.region}"
  aws_ecs_cluster_main_arn = module.base_infra.aws_ecs_cluster_main_arn
  aws_lb_target_group_api_arn = module.base_infra.aws_lb_target_group_api_arn
  aws_iam_role_execution_role_arn = module.base_infra.aws_iam_role_execution_role_arn
  aws_iam_role_task_role_arn = module.base_infra.aws_iam_role_task_role_arn
  aws_account_id= "${var.aws_account_id}"
  loki_ip = module.monitoring.ec2_private_ip
  database_url= module.db.db_url
  database_name = "${var.database_name}" 
  database_username = "${var.database_username}"
  database_password = "${var.database_password}"
  database_port     = "${var.database_port}"
  depends_on = [module.base_infra]
}


#################################
### Database service module  ####
#################################

module "db" {
  source  = "./db"
  name = "${var.project_identifier}-${var.stage}"
  vpc_id = module.base_infra.aws_vpc_main_id
  database_identifier = "${var.project_identifier}-${var.stage}-postgres"
  engine_version    = "9.6"
  instance_type     = "db.t2.micro"
  storage_type     = "gp2"
  allocated_storage = 32
  storage_encrypted = false
  database_name = "${var.database_name}" 
  database_username = "${var.database_username}"
  database_password = "${var.database_password}"
  database_port     = "${var.database_port}"
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = 0
  snapshot_identifier = "toptal-snapshot"
  aws_subnet_private_1_id = module.base_infra.aws_subnet_private_1_id
  aws_subnet_private_2_id = module.base_infra.aws_subnet_private_2_id
  aws_subnet_private_3_id = module.base_infra.aws_subnet_private_3_id
  depends_on = [module.base_infra]
}


#######################################
######### CICD PIPE LINE WEB  #########
#######################################


module "cicd_web" {
  source = "./cicd"
  name = "${var.project_identifier}-${var.stage}"
  region = "${var.region}"
  tier = "web"
  aws_account_id="${var.aws_account_id}"
  github_token = "${var.github_token}"
  github_owner = "${var.github_owner}"
  github_repo = "dhruv-toptal-web"
  github_branch = "main"
  depends_on = [module.web-service]
}

#####################################
######### CICD PIPELINE API  ########
#####################################


module "cicd_api" {
  source = "./cicd"
  name = "${var.project_identifier}-${var.stage}"
  region = "${var.region}"
  tier = "api"
  aws_account_id="${var.aws_account_id}"
  github_token = "${var.github_token}"
  github_owner = "${var.github_owner}"
  github_repo = "dhruv-toptal-api"
  github_branch = "main"
  depends_on = [module.api-service]
}