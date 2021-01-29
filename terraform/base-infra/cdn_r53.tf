module "log_storage" {
  source                   = "git::https://github.com/cloudposse/terraform-aws-s3-log-storage.git"
  name                     = "external-logs"
  stage                    = "prd"
  namespace                = "toptal"
  acl                      = "log-delivery-write"
  standard_transition_days = 30
  glacier_transition_days  = 60
  expiration_days          = 90
  force_destroy            = true
}

module "r53_alias_record" {
  source          = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=master"
  aliases         = ["www.${var.r53_domain_name}", var.r53_domain_name]
  parent_zone_id  = var.r53_hosted_zone_id
  target_dns_name = aws_cloudfront_distribution.web_cdn.domain_name
  target_zone_id  = "Z2FDTNDATAQYW2"      # This is always the hosted zone ID when you create an alias record that routes traffic to a CloudFront distribution. 
}

module "r53_alias_record_monitoring" {
  source          = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=master"
  aliases         = ["monitoring.${var.r53_domain_name}"]
  parent_zone_id  = var.r53_hosted_zone_id
  target_dns_name = aws_lb.monitoring_alb.dns_name
  target_zone_id  = aws_lb.monitoring_alb.zone_id 
}

module "r53_alias_record_api" {
  source          = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=master"
  aliases         = ["api.${var.r53_domain_name}"]
  parent_zone_id  = var.r53_hosted_zone_id
  target_dns_name = aws_lb.api_alb.dns_name
  target_zone_id  = aws_lb.api_alb.zone_id 
}

resource "aws_cloudfront_distribution" "web_cdn" {
  origin {
    domain_name = aws_lb.web_alb.dns_name
    origin_id   = "${var.name}-cdn-origin"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "match-viewer"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Toptal CDN"
  default_root_object = ""

  aliases = ["www.${var.r53_domain_name}",var.r53_domain_name]

  logging_config {
    include_cookies = false
    bucket          = module.log_storage.bucket_domain_name
    prefix          = "cdn"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}-cdn-origin"

    forwarded_values {
      query_string = true

      headers =  ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    ssl_support_method = "sni-only"
    acm_certificate_arn = var.acm_certificate_arn
  }
}

output "cdn_domain_name" {
  value = aws_cloudfront_distribution.web_cdn.domain_name
}