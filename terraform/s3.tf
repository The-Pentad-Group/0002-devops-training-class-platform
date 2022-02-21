resource "aws_s3_bucket" "b" {
  bucket = "tpg-training-bucket-h894d3"

  tags = {
    Name        = "training-bucket"
    Environment = "tpg-training"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}
