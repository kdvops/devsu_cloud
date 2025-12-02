resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  comment             = "CDN for ${var.name}"
  default_root_object = "index.html"

  aliases = var.aliases

  origin {
    domain_name = var.s3_bucket_website_endpoint
    origin_id   = "s3-origin-${var.name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
    # Required
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin-${var.name}"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }



  viewer_certificate {
    #acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
    #ssl_support_method             = var.acm_certificate_arn != "" ? "sni-only" : null
    #minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
  }
}

