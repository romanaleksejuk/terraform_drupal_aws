resource "aws_efs_file_system" "drupal-efs" {
  creation_token = "drupal-efs-${var.environment}"

  tags = {
    Name = "drupal-efs-${var.environment}"
  }
}

resource "aws_efs_mount_target" "drupal-efs-target" {
  file_system_id = aws_efs_file_system.drupal-efs.id
  subnet_id      = aws_subnet.drup-private-1.id
  security_groups = [aws_security_group.efs-sg.id]
}

resource "aws_efs_mount_target" "drupal-efs-target2" {
  file_system_id = aws_efs_file_system.drupal-efs.id
  subnet_id      = aws_subnet.drup-private-2.id
  security_groups = [aws_security_group.efs-sg.id]
}

resource "aws_efs_mount_target" "drupal-efs-target3" {
  file_system_id = aws_efs_file_system.drupal-efs.id
  subnet_id      = aws_subnet.drup-private-3.id
  security_groups = [aws_security_group.efs-sg.id]
}