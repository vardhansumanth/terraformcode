output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.example.name
}
