resource "random_id" "id" {
  byte_length = 4
}

# -----------------------------
# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "app" {
  bucket        = "devsu-app-${random_id.id.hex}"
  #bucket        = "${var.bucket_name}-${random_id.id.hex}"
  force_destroy = true   # permite destruir aunque tenga archivos
}

# -----------------------------
# Habilitar Static Website Hosting
# -----------------------------
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.app.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# -----------------------------
# ACL pública (requerido para webs públicas)
# -----------------------------
#resource "aws_s3_bucket_acl" "public_acl" {
#  bucket = aws_s3_bucket.app.id
#  acl    = "public-read"
#}

# -----------------------------
# Desbloquear acceso público
# -----------------------------
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -----------------------------
# Bucket Policy para permitir leer objetos (GetObject)
# -----------------------------
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.app.id

  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.app.arn}/*"
      }
    ]
  })
}
