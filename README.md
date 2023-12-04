# ecom-rds-terraform
# ecom-rds-terraform


# RDS

# I created a VPC which has public and private subnets which is created in 2 AZs for high availability
# IGW normally be deployed, although not in the terraform code it will received traffics from the pubic and send to ALB
# ALB deployed in the public subnet
# ALB sends traffic into the ECS cluster
# I AM
 I have completed this task as required. To start I created a IAM role and attached policies to this include    ECS tasks execution and S3  access. Please note that I have used services for ECS and S3 policies including S3: Access i.e  Get Object, Put Object and delete Object .

 
# For ECS, I created an ESC resource cluster, created  ESC task definition  which specified memory, CPU etc and Fargate and then created an ECS service.
 
# Service was used to create 2 tasks

Container
Please see the terraform code
 
# The server deployed runs in a cluster of EC2 which is connected to the deployed RDS DB ( MySQL compatible).  Pease see the terraform code for specification. This DB is also multi-AZ enabled. On the DB, there is enhanced monitoring role and subnet created. Because of time constraints, no website server is put up for this task.
 
# Due to my knowledge of AWS I prefer to use Fargate which is an AWS managed service because it can help to  manage EC2 instances thereby reducing workload on the business. 
 
# I have also used S3 so files can be saved  and archived with glacier as per business requirements
 
#  Security is as per the terraform file of EC2 using Terraform. 
