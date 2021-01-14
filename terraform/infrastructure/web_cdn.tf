resource "aws_cloudfront_distribution" "web_cdn" {
  origin {
    domain_name = aws_lb.web_alb.dns_name
    origin_id   = "${var.name}-cdn-origin"

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "Toptal CDN"
  default_root_object = ""

  aliases = []

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

    viewer_protocol_policy = "allow-all"
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
    cloudfront_default_certificate = true
  }
}

output "cdn_url" {
  value = aws_cloudfront_distribution.web_cdn.domain_name
}