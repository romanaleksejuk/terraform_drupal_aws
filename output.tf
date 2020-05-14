output "beanstalk_main_url" {
	value = aws_elastic_beanstalk_environment.drupal-prod.cname
}
# output "efs" {
# 	value = aws_efs_file_system.drupal-efs.id
# }

output codecommit_repo_url_http {
  value = aws_codecommit_repository.drupal.clone_url_http
  description = "The http url of Codecommit repo."
}

output database_instance_address {
  value = aws_db_instance.mysqldb.address
  description = "RDS instance hostname."
}

output database_name {
  value = aws_db_instance.mysqldb.name
  description = "RDS database name."
}

output database_username {
  value = aws_db_instance.mysqldb.username
  description = "RDS database username."
}

output database_password {
  value = aws_db_instance.mysqldb.password
  description = "RDS database password."
}