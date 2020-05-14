resource "tls_private_key" "drupal_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "drupal" {
  public_key = tls_private_key.drupal_key.public_key_openssh
}

# resource "aws_key_pair" "drupal" {
#   key_name = "drupal-${var.environment}"
#   public_key = file("${var.PATH_TO_PUBLIC_KEY}")
#   lifecycle {
#     ignore_changes = [public_key]
#   }
# }
