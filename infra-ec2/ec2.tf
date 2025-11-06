locals {
  ecr_url = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repo_name}:latest"
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu_22.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  key_name                    = var.key_name

  user_data = <<-EOF
    #!/usr/bin/env bash
    set -e

    # install docker
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" > /etc/apt/sources.list.d/docker.list
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io

    systemctl enable docker
    systemctl start docker

    # login to ECR (instance role provides auth)
    REGION="${var.region}"
    ECR="${local.ecr_url}"
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${var.account_id}.dkr.ecr.$REGION.amazonaws.com

    # pull & run container (restart always)
    docker pull $ECR || exit 1
    docker rm -f fastapi || true
    docker run -d --restart=always --name fastapi -p ${var.host_port}:${var.container_port} $ECR
  EOF

  tags = {
    Name = "fastapi-ec2"
  }
}
