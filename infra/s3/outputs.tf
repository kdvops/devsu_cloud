output "bucket_name" {
  value = aws_s3_bucket.app.id
}


#output "website_url" {
#  value = aws_s3_bucket.app.website_endpoint
#}


output "bucket_arn" {
  value = aws_s3_bucket.app.arn
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.app.bucket_regional_domain_name
}


output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}