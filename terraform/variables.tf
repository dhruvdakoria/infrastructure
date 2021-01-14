
#################################
###### General Variables ########
#################################



variable "aws_account_id" {
  default = "766050608330"
  description = "AWS ACCOUNT ID"
}

variable "module_name" {
  default = "dhruv-toptal"
  description = "Module name"
}

variable "stage" {
  default = "prd"
}

variable "region" {
  default = "us-east-1"
}

#################################
###### Pipeline Variables #######
#################################


variable "github_token" {
  default = "51e701fb9ba45dd02be789c1ff0938a73abd4102"
  description = "Github token which will be used for build"
}

variable "github_owner" {
  default = "dhruvdakoria"
  description = "Github owner accout where repos are"
}


#################################
###### Database Variables #######
#################################

variable "database_password" {
  default = "securepassword"
}

variable "database_username" {
  default = "toptal"
}
