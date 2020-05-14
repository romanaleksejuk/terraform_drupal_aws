variable "aws_region" {
  type = string
  default = "eu-central-1"
  description = "The AWS region."
}
# variable "PATH_TO_PRIVATE_KEY" {
#   type = string
#   default = "./keys/drupal"
# }
# variable "PATH_TO_PUBLIC_KEY" {
#   type = string
#   default = "./keys/drupal.pub"
# }
variable "rds_password" {
  type = string
  description = "RDS database service password."
}
variable "environment" {
  type = string
  default = "prod"
  description = "Environment name (e.g. prod, stage, or dev)."
}
