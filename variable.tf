
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-08bf489a05e916bbd" 
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  default     = 2
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  default     = 1
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  default     = "my-static-assets"
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket to store Terraform state"
  default     = "terraform-state-bucket"
}
