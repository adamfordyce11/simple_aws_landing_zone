resource "aws_db_subnet_group" "production_subnets" {
  name       = "production_subnets"
  subnet_ids = [aws_subnet.privatez2a.id, aws_subnet.privatez2b.id]

  tags = {
    Name = "Private Subnet Group"
    VPC  = "production"
  }
}
resource "aws_security_group" "production_rds_sg" {
  name        = "production_rds_sg"
  description = "Allow MySql connections"
  vpc_id      = aws_vpc.prodution.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.webserver.id]
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.webserver.id]
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "production_rds_sg"
    VPC  = "production"
  }
}

resource "aws_db_parameter_group" "production_rds_params" {
  name   = "production-rds-params"
  family = "mysql8.0"

  parameter {
    name  = "autocommit"
    value = "1"
  }
}

resource "aws_db_instance" "production_rds" {
  identifier             = "production-rds"
  instance_class         = "db.t3.medium"
  storage_type           = "gp2"
  allocated_storage      = 30
  max_allocated_storage  = 100
  engine                 = "mysql"
  engine_version         = "8.0.28"
  username               = "proddbroot"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.production_subnets.name
  vpc_security_group_ids = [aws_security_group.production_rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.production_rds_params.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}