# iam user
resource "aws_iam_user" "drupal" {
  name = "drupal-${var.environment}"
  path = "/"
}

resource "aws_iam_access_key" "drupal" {
  user = aws_iam_user.drupal.name
}

resource "aws_iam_user_policy" "drupal" {
  name = "drupal-${var.environment}"
  user = aws_iam_user.drupal.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# iam roles
resource "aws_iam_role" "drupal-ec2-role" {
    name = "drupal-ec2-role-${var.environment}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "drupal-ec2-role" {
    name = "drupal-ec2-role-${var.environment}"
    role = aws_iam_role.drupal-ec2-role.name
}

# service
resource "aws_iam_role" "elasticbeanstalk-service-role" {
    name = "elasticbeanstalk-service-role-${var.environment}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# policies
resource "aws_iam_role_policy_attachment" "drupal-attach1" {
    role = aws_iam_role.drupal-ec2-role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
resource "aws_iam_role_policy_attachment" "drupal-attach2" { 
    role = aws_iam_role.drupal-ec2-role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}
resource "aws_iam_role_policy_attachment" "drupal-attach3" {
    role = aws_iam_role.drupal-ec2-role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
resource "aws_iam_role_policy_attachment" "drupal-attach4" {
    role = aws_iam_role.elasticbeanstalk-service-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
