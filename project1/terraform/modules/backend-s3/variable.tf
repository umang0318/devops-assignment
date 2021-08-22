variable "project-name" {
  type        = string
  description = "project name"
}

variable "env" {
  type        = string
  description = "environment name"
}

variable "bucket_sse_algorithm" {
  type        = string
  description = "Encryption algorith to use on the S3 bucket"
  default     = "AES256"
}