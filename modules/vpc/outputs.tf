output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids_private" {
  value = aws_subnet.private[*].id
}