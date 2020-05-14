
# Drupal CMS auto-deployment (with CI/CD pipeline) into AWS using Terraform
### 1) Basic scheme/pipeline:

>AWS CodeCommit repo (CI) -> AWS CodePipeline (CD) -> Load Balanced AWS Beanstalk (with external EFS filesystem + external RDS database)

* AWS CodeCommit is for public repo and Drupal CMS PHP source upload.
* AWS CodePipeline is for changes detection in repo and auto deploying PHP sources to AWS Beanstalk.
* External RDS database service is for Drupal db.
* External EFS system is to retain the Drupal settings.
* All infrastructure elements are put into separate VPC.
* There are private (for EFS, RDS, Beanstalk EC2 instances) and public (IGW, NATGW, CodeCommit, CodePipeline, Beanstalk LoadBalancer) subnets.
* External EFS Filesystem service is being mounted via AWS Elastic Beanstalk configuration files located in Drupal source archive drupal_repo.zip (.ebextensions/efs-mount.config) to "/drupalfiles". "/drupalfiles" is being symlinked to "sites/default" directory inside the Beanstalk EC2.
* "var.environment" variable in Terraform script files is used to deploy the infrastructure into separate envs (dev/prod).

### 2) Prerequisites
 - Install `Terraform` (https://www.terraform.io/downloads.html)
 - Install `Git` (https://git-scm.com/download/)

### 3) Package directories
```
├── drupal_repo.zip  #drupal original PHP source files archive + ".ebextensions" directory inside for mounting the EFS filesystem
├── ...Terraform scripts...
```

### 4) Deployment
##### — Export your AWS credentials:
```
export AWS_ACCESS_KEY_ID=<your_access_key>
export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>
```
##### — Edit "vars.tfvar" variables:

```
environment = <environment_name> #(e.g. "prod" or "dev")
rds_password = <password_for_rds_database>
```
##### — Run `Terraform` scripts:
```
terraform init
terraform apply -var-file="vars.tfvars"
```
##### — Wait for AWS CodeCommit + AWS CodePipeline + AWS Beanstalk + AWS EFS + AWS RDS creation (5-10min)

##### — Generate AWS CodeCommit GIT credentials for existent user (in order to get access/push to AWS CodeCommit repo):
```
AWS Web console -> Services -> IAM  -> Users -> [User] -> Security Credentials -> HTTPS Git credentials for AWS CodeCommit -> Generate Credentials 
```
##### — Extract "drupal_repo.zip" source files, create `git` repository and push them to AWS CodeCommit repo via <codecommit_repo_url> returned by Terraform scripts:
```
git init
git add .
git -am "Initial commit"
git remote add origin <codecommit_repo_url>
git push origin master
```
##### — Wait for AWS CodePipeline to detect a new changes in AWS CodeCommit repo and upload them to AWS Beanstalk

##### — Visit the AWS Beanstalk url returned by Terraform script to proceed with Drupal installation (use other Terraform scripts return values, e.g. <database_name>, <database_address>)


