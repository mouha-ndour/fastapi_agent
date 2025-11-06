output "public_ip" {
  value = aws_instance.app.public_ip
}

output "ecr_url" {
  value = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repo_name}:latest"
}
