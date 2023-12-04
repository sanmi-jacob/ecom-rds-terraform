# ecom-rds-terraform
# ecom-rds-terraform


# RDS

# I created a VPC which has public and private subnets which is created in 2 AZs for high availability
# IGW normally be deployed, although not in the terraform code it will received traffics from the pubic and send to ALB
# ALB deployed in the public subnet
# ALB sends traffic into the ECS cluster

# For ECS, I created an ESC resource cluster, created  ESC task definition  which specified memory, CPU etc and Fargate and then created an ECS service.
 
# Service was used to create 2 tasks

# The server deployed runs in a cluster of EC2 which is connected to the deployed RDS DB ( MySQL compatible).  Pease see the terraform code for specification. This DB is also multi-AZ enabled. On the DB, there is enhanced monitoring role and subnet created. Because of time constraints, no website server is put up for this task.
 
# Due to my knowledge of AWS I prefer to use Fargate which is an AWS managed service because it can help to  manage EC2 instances thereby reducing workload on the business. 

# IAM
 To start I created a IAM role and attached policies to this include    ECS tasks execution and S3  access. Please note that I have used services for ECS and S3 policies including S3: Access i.e  Get Object, Put Object and delete Object .

 

# I have also used S3 so files can be saved  and archived with as per business requirements. There are different cheap options that can be annexed here
 
#  Security is as per the terraform file of EC2 using Terraform. 
