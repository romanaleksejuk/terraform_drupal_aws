resource "aws_db_subnet_group" "mysqldb-subnet" {
    name  = "mysqldb-subnet-drup-${var.environment}"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.drup-private-1.id}","${aws_subnet.drup-private-2.id}"]
}

resource "aws_db_parameter_group" "mysqldb-parameters" {
    name = "mysqldb-params-drup-${var.environment}"
    family = "mysql5.6"
    description = "MySQLDB parameter group"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
   }

}


resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10    
  engine               = "mysql"
  engine_version       = "5.6.39"
  instance_class       = "db.t2.micro"    
  identifier           = "mysql${var.environment}"
  name                 = "drupaldb${var.environment}"
  username             = "root"
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.mysqldb-subnet.name
  parameter_group_name = aws_db_parameter_group.mysqldb-parameters.name
  multi_az             = "false"
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  storage_type         = "gp2"
  backup_retention_period = 30
  skip_final_snapshot = true
  availability_zone = aws_subnet.drup-private-1.availability_zone
  tags = {
      Name = "mysqldb-instance-${var.environment}"
  }
}
