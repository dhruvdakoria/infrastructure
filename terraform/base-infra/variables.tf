variable "name" {
  description = "Name of the cluster"
}

variable "region" {
  description = "Region of cluster"
}

variable "ecs_key_pair_name" {
  description = "Key pair name"
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN"
}

variable "r53_domain_name" {
  description = "Domain Name used for creating R53 hosted zone"
}

variable "r53_hosted_zone_id" {
  description = "Hosted Zone ID for R53"
}