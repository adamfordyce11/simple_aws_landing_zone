resource "aws_security_group" "webserver" {
  name        = "wordpress"
  description = "Allow http, https and ssh"
  vpc_id      = aws_vpc.production.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
    VPC  = "production"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.public.id
}

locals {
  vars = {
    public_ip = "${aws_eip.public.public_ip}"
  }
}


resource "aws_instance" "wordpress" {
  ami                         = "ami-00826bd51e68b1487"
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.webserver.id]
  associate_public_ip_address = true
  key_name                    = "production"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 30
    volume_type = "gp3"
    tags = {
      Name = "sites"
      VPC  = "production"
    }
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_size = 15
    volume_type = "gp3"
    tags = {
      Name = "mysql"
      VPC  = "production"
    }
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 5
    volume_type = "gp3"
    tags = {
      Name = "cache"
      VPC  = "production"
    }
  }

  user_data = base64encode(templatefile("${path.module}/templates/bootstrap.sh", local.vars))

  tags = {
    Name = "wordpress"
    VPC  = "production"
    AMI  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220419"
  }
}

resource "aws_eip" "public" {
  vpc = true
}


resource "aws_iam_role" "website_s3_backup_role" {
  name = "website_s3_backup_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "website_s3_backup"
    VPC  = "production"
  }
}
