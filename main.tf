data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example" {
  name               = "example-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_launch_configuration" "example" {
  image_id          = var.ami_id
  instance_type     = var.instance_type
  user_data         = <<-EOF
                      #!/bin/bash
                      yum install -y nginx
                      service nginx start
                      EOF
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  vpc_zone_identifier  = aws_subnet.private[*].id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
}

resource "aws_s3_bucket" "static_assets" {
  bucket = "my-static-assets-bucket" 
  acl    = "public-read"

  tags = {
    Name        = "Static Assets Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "static_assets_policy" {
  bucket = aws_s3_bucket.static_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.static_assets.arn}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = ["10.0.0.0/24"]  # Change this to your desired IP range
          }
          StringLike = {
            "aws:Referer" = ["https://www.example.com/*"]  # Change this to your allowed referrer
          }
        }
      }
    ]
  })
}

