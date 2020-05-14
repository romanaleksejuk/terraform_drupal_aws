resource "aws_security_group" "beanstalk-sg" {
  vpc_id = aws_vpc.drupal-vpc.id
  name = "beanstalk-sg-${var.environment}"
  description = "security group for Beanstalk."
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "drupal-${var.environment}"
  }
}

resource "aws_security_group" "efs-sg" {
  vpc_id = aws_vpc.drupal-vpc.id
  name = "efs-sg-${var.environment}"
  description = "security group for EFS service."
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 2049
      to_port = 2049
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "drupal-${var.environment}"
  }
}

resource "aws_security_group" "rds-sg" {
  vpc_id = aws_vpc.drupal-vpc.id
  name = "rds-sg-${var.environment}"
  description = "Secutiry group for AWS RDS database."
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "tcp"
      security_groups = [aws_security_group.beanstalk-sg.id]           
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self = true
  }
  tags = {
    Name = "drupal-${var.environment}"
  }
}
