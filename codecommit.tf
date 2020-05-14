resource "aws_codecommit_repository" "drupal" {
  repository_name = "drupal-${var.environment}"
  description     = "This is the drupal repo"
  # provisioner "local-exec" {
  #   command = "./initial-commit.sh ${aws_codecommit_repository.application.clone_url_ssh} "
  #   working_dir = "../../${var.project_name}"
  # }

}

