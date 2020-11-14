terraform {
  backend "s3" {
    bucket         = "nutriform-bucket-state"
    key            = "global/s3/terraform.tfstate"
    region         = "app-northeast-1"
    dynamodb_table = "nutriform-dynamodb-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
  # profile = "seb"
}

module "my_vpc" {
    source                  = "./modules/vpc"
    #vpc_cidr                = "155.0.0.0/16"
    #public_subnets_cidr     = ["155.0.1.0/24", "155.0.2.0/24"]
    #private_subnets_cidr    = ["155.0.3.0/24", "155.0.4.0/24"]
    #azs                     = ["ca-central-1a", "ca-central-1b"]
    prefix_name             = var.prefix_name
}

# module "my_s3" {
#     source                  = "./modules/s3"
#     bucket_name             = var.bucket_name
#     path_folder_content     = "./src/"
# }

module "my_ec2_role_allow_s3" {
    source                  = "./modules/ec2_role_allow_s3"
    prefix_name             = var.prefix_name
    bucket_name             = var.bucket_name
}


module "my_alb_asg" {
    source               = "./modules/alb_asg"
    webserver_port       = 80
    webserver_protocol   = "HTTP"
    instance_type        = "t2.micro"
    private_subnet_ids   = module.my_vpc.private_subnet_ids
    public_subnet_ids    = module.my_vpc.public_subnet_ids
    role_profile_name    = module.my_ec2_role_allow_s3.name
    min_instance         = 2
    desired_instance     = 2
    max_instance         = 2
    ami                  = data.aws_ami.ubuntu-ami.id
    path_to_public_key   = "/home/fitec/monprojet/Terraform/NutriForm/DEV/keys/nutriform.pub"
    vpc_id               = module.my_vpc.vpc_id
    prefix_name          = var.prefix_name
    user_data = <<-EOF
    EOF  
}

module "my_rds" {
  source                   = "./modules/rds"
  webserver_sg_id          = module.my_alb_asg.webserver_sg_id
  prefix_name              = "nutrifom-mysqldb"
  private_subnet_ids       = module.my_vpc.private_subnet_ids
  #storage_gb               = 10
  vpc_id                   = module.my_vpc.vpc_id
  #mariadb_version          = "10.1.34"
  #mariadb_instance_type    = "db.t2.small"
  #mysql_version             = "8.0.20"
  #mysql_instance_type       = "db.t2.micro"
  db_name                  = "nutriform"
  db_username              = "nutriformadmin"
  db_password              = var.db_password
  #is_multi_az              = false
  #storage_type             = "gp2"
  #backup_retention_period  = 1
}