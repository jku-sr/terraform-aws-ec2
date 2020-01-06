
output "public_ip" {
  value = aws_instance.web[0].public_ip
}

output "sg_id" {
  value = aws_security_group.this.id
}