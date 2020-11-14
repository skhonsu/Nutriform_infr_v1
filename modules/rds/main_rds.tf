# Security group of the db
resource "aws_security_group" "mysql-sg" {
  vpc_id            = var.vpc_id
  name              = var.prefix_name
  description       = "security group for the database"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.webserver_sg_id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }
  tags = {
    Name = "${prefix_name}-mysql"
  }
}

# Subnets of the db
resource "aws_db_subnet_group" "mysql-subnet" {
  name        = "mysql-subnet"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnet_ids
}

# Parameters of the db (mysql)
resource "aws_db_parameter_group" "mysql-parameters" {
  name        = "mysql-params"
  family      = "mysql8.0"
  description = "Mysql parameter group"

  ## Parameters example
  # parameter {
  #   name  = "max_allowed_packet"
  #   value = 16777216
  # }
}

# Db instance

#Create RDS DB
resource "aws_db_instance" "mysqldb" {
  allocated_storage       = var.storage_gb
  storage_type            = var.storage_type
  engine                  = "mysql"
  engine_version          = var.mysql_version
  instance_class          = var.mysql_instance_type
  identifier              = "nutriform"
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.mysql-subnet.name
  parameter_group_name      = aws_db_parameter_group.mysql-parameters.name
  multi_az                  = var.is_multi_az
  vpc_security_group_ids    = [aws_security_group.mysql-sg.id]
  backup_retention_period   = var.backup_retention_period
  #backup_window           = "09:46-10:16"
  #skip_final_snapshot     = true
  final_snapshot_identifier = "${prefix_name}-snapshot" # final snapshot when executing terraform destroy
  tags = {
   Name = "${prefix_name}-mysql"
  }
  
}

# With MariaDB
#resource "aws_db_instance" "mariadb" {
  #allocated_storage         = var.storage_gb
  #engine                    = "mariadb"
  #engine_version            = var.mariadb_version
  #instance_class            = var.mariadb_instance_type
  #identifier                = "mariadb"
  #name                      = var.db_name
  #username                  = var.db_username
  #password                  = var.db_password
  #db_subnet_group_name      = aws_db_subnet_group.mariadb-subnet.name
  #parameter_group_name      = aws_db_parameter_group.mariadb-parameters.name
  #multi_az                  = var.is_multi_az
  #vpc_security_group_ids    = [aws_security_group.mariadb-sg.id]
  #storage_type              = var.storage_type
  #backup_retention_period   = var.backup_retention_period
  #final_snapshot_identifier = var.prefix_name # final snapshot when executing terraform destroy
  #tags = {
   # Name = var.prefix_name-mariadb
  #}


  #Create RDS DB READ REPLICA
#resource "aws_db_instance" "rds_read_replica" {
  #allocated_storage    = 20
  #storage_type         = "gp2"
  #engine               = "mysql"
  #engine_version       = "8.0"
  #instance_class       = "db.t2.micro"
  #name                 = var.db_name
  #username             = var.user_username
  #password             = var.user_password
  #parameter_group_name = "default.mysql8.0"
  #skip_final_snapshot  = true
 # replicate_source_db  = aws_db_instance.tf_rds_wp.arn
#}