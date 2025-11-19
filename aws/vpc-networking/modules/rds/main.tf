# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-db-subnet-group"
    }
  )
}

# RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = "gp3"
  db_name                = var.database_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

  backup_retention_period = 0

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-mysql"
    }
  )
}

