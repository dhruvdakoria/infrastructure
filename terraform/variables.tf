# Generic vars
variable "aws_account_id" {
  default = "444716747145"
  description = "AWS ACCOUNT ID"
}

variable "project_identifier" {
  default = "dhruv-toptal"
  description = "Project Identifier"
}

variable "key_pair_name" {
  default = "dhruv_toptal_kp"
  description = "Key Pair Name"
}

variable "stage" {
  default = "prd"
}

variable "region" {
  default = "us-east-1"
}

#CI/CD pipeline variables
variable "github_token" {
  default = "51e701fb9ba45dd02be789c1ff0938a73abd4102"
  description = "Github token which will be used for build"
}

variable "github_owner" {
  default = "dhruvdakoria"
  description = "Github owner accout where repos are"
}

variable "github_branch" {
  default = "master"
}

#database related variables
variable "database_password" {
  default = "toptalpassword"
}

variable "database_username" {
  default = "toptal"
}
variable "database_name" {
  default = "toptaldb"
}
variable "database_port" {
  default = "5432"
}