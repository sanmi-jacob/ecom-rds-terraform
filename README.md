# ecom-rds-terraform
# ecom-rds-terraform

# I AM
 I have completed this task as required. To start I created a IAM role and attached policies to this include    ECS tasks execution and S3  access. Please note that I have used services for ECS and S3 policies including S3: Access i.e  Get Object, Put Object and delete Object .
 
Container
A container with base image Nginx also created and port 80 OPEN
 
# VPC
# I created a VPC which has public and private subnets which is created in 2 AZs for high availability
# IGW is deployed and will received traffics from the pubic and send to ALB
# ALB deployed in the public subnet
# ALB sends traffic into the ECS cluster
 
# For ESC, I created an ESC resource cluster, created  ESC task definition  which specified memory etc and Fargate and then created an ECS service.
 
# Service was used to create 2 tasks
 
# The server deployed runs in a cluster of EC2 which is connected to the RDS DB. 
Because of time constraints, no website server is put up for this task.
 
# I have used Fargate which is an AWS managed service because it can help to  manage EC2 instances thereby reducing workload on the business. Please note that the Autoscaling group could also be used to manage clusters of EC2, however for better optimization as per serverless EC2 I have gone the route of ECS and Fargate. 
 
# I have also used S3 so files can be saved  and archived with glacier as per business requirements
 
#  Security is as per the terraform file of EC2 using Terraform.
