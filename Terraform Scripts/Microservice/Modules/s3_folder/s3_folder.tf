## S3 bucket folder create folder 
resource "aws_s3_object" "folders" {
  bucket = var.bucket_name
  key    = var.folder_name
}