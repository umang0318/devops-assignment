variable "region" {
  default = "ap-southeast-2"
}

variable "vpc_id" {
  type = string
  default = ""
}
variable "vpc_cidr" {
  type = string
  default = ""
}
variable "project-name" {
  description = "Project Name"
  type = string
}
variable "env" {
  description = "Environment"
  type = string
}
variable "ec2_ami_id" {
  description = "AMI to create EC2"
  type        = string
}
variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"  
}
variable "ebs_volume_size" {
  description = "EBS volume Size"
  type        = number
  default     = 1
}

variable "ebs_block_device_name" {
  description = "EBS block device name"
  type        = string
  default     = "/dev/xvdb"
}

variable "access_key_location" {
  description = "Access Key location"
  type        = string
  default     = ""
}
