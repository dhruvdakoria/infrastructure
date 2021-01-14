# Toptal project

This repository is created for purpose of the toptal task.

## Getting Started

The project consists of three repositories:

* web
* api
* infrastructure

NOTE: In order for automation script to work you have to create these three repositories in your Github (with same naming)

### Prerequisites

You need to install following applications:

* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [GitHub](https://github.com)(The automation scripts work only with github repositories)
* [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)



### Starting local environment

The application can be started locally with docker compose. To do this you need to clone current repository:

```
git clone https://github.com/<owner>/infrastructure.git
git clone https://github.com/<owner>/web.git
git clone https://github.com/<owner>/api.git
```

And run the docker compose which in infrastructure/local/ path

```
docker-compose up inside 

```

This script will create web and api docker image localy 

You can access the web in:

```
http://localhost
```

## Starting cloud environment

We will create the infrastructure for the application in AWS cloud using aws cli and terraform. We need to follow the steps bellow to start the infrastructure.

### 1. Configure AWS CLI

Create a user in AWS which has administrator access. Add credentials in local environment following this [url] (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

### 2. Configure Terraform variables

Open variable.tf file which is in ./terraform directory of infrastructure repository. Fill the following variables:

| Variable          | Description                                                        | Example value                            |
|-------------------|--------------------------------------------------------------------|------------------------------------------|
| aws_account_id    | Your AWS account id                                                | 740900581647                             |
| module_name       | Name your application name                                         | toptal                                   |
| stage             | Stage that will use your infrastructure                            | prod                                     |
| region            | Your AWS region                                                    | eu-central-1                             |
| github_token      | Github token which has access to pull the repos and watch triggers | 1234ae31ffdb89fb9f059126666ab4a62aba3566 |
| github_owner      | Github account name                                                | kushtrimm                                |
| database_password | Postgresql database password                                       | securepassword                           |
| database_username | Postgresql database username                                       | toptal                                   |

### 3. Create S3 bucket and DynamoDB table to keep terraform state

In your terminal run the following command to create S3 bucket to keep terraform state:

```
aws s3api create-bucket --bucket toptal-terrastate --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1
```
This will create toptal-terrastate bucket in AWS in eu-central-1 region. To create the DynamoDB table run following command:

```
aws dynamodb create-table --table-name toptal-terrastate-db --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

```
This will create toptal-terrastate-db DynamoDB table in AWS. This will be used for locl file for terraform state.

If you change the name of bucket or DynamoDB table please edit backend.tf file in terraform directory:


```
terraform {  
    backend "s3" {
        bucket         = "toptal-terrastate"
        key            = "terraform.tfstate"    
        region         = "eu-central-1"
        dynamodb_table = "toptal-terrastate-db"
    }
}
```


### 4. Create infrastructure, pipelines, services and database

Run the following command in ./terraform directory to create infrastructure pipelines, services and database:

```
terraform init

terraform apply

```
When prompted, please type **yes** to approve changes

When the deployment is finished a url of ALB is generated. You can copy that url to access the application or you can add as CNAME record in your DNS (You may need to wait for few minutes untill the application is up and running).

## Architecture

All infrastructure is based on AWS services. We will use AWS CodeBuild, AWS CodePipeline for builds, AWS ECS for application hosting, AWS RDS for database and CloudWatch logs for logs and monitoring.

![Architecture](https://git.toptal.com/morina.kushtrim/node-3tier-app2/blob/master/infrastructure/Diagram.jpg)


### Components

In high level we can split the infrastructure in three components:

* CI/CD
* Infrastructure
* monitoring

#### CI/CD

* [AWS CodeBuild](https://aws.amazon.com/codebuild/) - used for building the docker images and pushing them to ECR registry
* [AWS CodePipeline](https://aws.amazon.com/codepipeline/) - used to trigger the build and to deploy the services in ECS cluster
* [AWS ECR](https://aws.amazon.com/ecr/) - used to store the docker images


#### Infrastructure

* [AWS Elastic Container Service](https://aws.amazon.com/ecs/)
* [AWS VPC](https://aws.amazon.com/vpc/)
* [AWS Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/)
* [AWS Auto scaling groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html)
* [AWS RDS](https://aws.amazon.com/rds/)


#### Monitoring

* [AWS CloudWatch](https://aws.amazon.com/cloudwatch/)
