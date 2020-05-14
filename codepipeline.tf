resource "random_id" "codepipeline_s3_bucket_random" {
  keepers = {
    # Generate a new id each time we switch to a new environment.
    codepipeline_name = "${var.environment}"
  }

  byte_length = 8
}

resource "aws_s3_bucket" "drupal" {
  bucket = "drupal-${random_id.codepipeline_s3_bucket_random.dec}-${var.environment}"
  acl    = "private"
  force_destroy = true
}

resource "aws_iam_role" "drupal-pipeline" {
  name = "drupal-pipeline-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy-${var.environment}"
  role = aws_iam_role.drupal-pipeline.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning"
      ],
      "Resource": [
        "${aws_s3_bucket.drupal.arn}",
        "${aws_s3_bucket.drupal.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:*",
        "elasticbeanstalk:*",
        "s3:*",
        "cloudformation:*",
        "ec2:*",
        "autoscaling:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "drupal-pipeline" {
  name     = "drupal-pipeline-${var.environment}"
  role_arn = aws_iam_role.drupal-pipeline.arn

  artifact_store {
    location = aws_s3_bucket.drupal.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["test"]

      configuration = {
        RepositoryName      = "drupal-${var.environment}"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["test"]
      version         = "1"

      configuration = {
        ApplicationName = "drupal-${var.environment}"
        EnvironmentName = "drupal-${var.environment}"
      }
    }
  }
}