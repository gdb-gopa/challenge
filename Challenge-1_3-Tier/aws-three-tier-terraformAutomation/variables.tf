variable "region" {
  default     = "us-west-2"
}

variable "dns_name" {
  description = "DNS Name Entry"
  type = string   
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  default     = "3-tier"
}

variable "public_subnets_cidr_blocks" {
  description = "CIDR blocks - DMZ"
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "web_subnets_cidr_blocks" {
  description = "CIDR blocks - Web Tier"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "app_subnets_cidr_blocks" {
  description = "CIDR blocks - App Tier"
  default     = ["10.0.6.0/24", "10.0.7.0/24"]
}

variable "db_subnets_cidr_blocks" {
  description = "CIDR blocks - DB Tier"
  default     = ["10.0.8.0/24", "10.0.9.0/24"]
}

variable "rds_subnet_name" {
  description = "Name - RDS subnet group"
  default     = "rds"
}

variable "rds_storage" {
  description = "RDS storage space"
  default     = "10"
}

variable "rds_engine" {
  description = "RDS engine type"
  default     = "mysql"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  default     = "db.t2.micro"
}

variable "rds_name" {
  description = "Name - RDS"
  default     = "mysql_rds"
}

variable "rds_username" {
  description = "Username of the RDS"
  default     = "mysql_tf"
}

variable "rds_password" {
  description = "Password of the RDS"
  default     = "rdsterraform"
}

variable "websg_name" {
  description = "Name of Web Security Group"
  default     = "web_sg"
}

variable "web_ami" {
  description = "AMI - Web"
  default     = "ami-830c94e3"
}

variable "web_instance" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "webserver_name" {
  description = "Name - web servers"
  default     = ["web1", "web2"]
}

variable "app_ami" {
  description = "AMI - App"
  default     = "ami-830c94e3"
}

variable "app_instance" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "appserver_name" {
  description = "Name - app servers"
  default     = ["app1", "app2"]
}

variable "dbsg_name" {
  description = "Name of DB Security Group"
  default     = "db_sg"
}

variable "lb_name" {
  description = "Name - ALB"
  default     = "weblb"
}

variable "tg_name" {
  description = "Name - ALB TG"
  default     = "weblb-tg"
}

variable "tg_port" {
  description = "Enter the port - ALB TG"
  default     = "80"
}

variable "tg_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTP"
}

variable "listener_port" {
  description = "Enter the port - ALB TG"
  default     = "443"
}

variable "listener_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTPS"
}

variable "applb_name" {
  description = "Name - ALB"
  default     = "applb"
}

variable "apptg_name" {
  description = "Name - ALB TG"
  default     = "applb-tg"
}

variable "apptg_port" {
  description = "Enter the port - ALB TG"
  default     = "80"
}

variable "apptg_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTP"
}

variable "applistener_port" {
  description = "Enter the port - ALB TG"
  default     = "443"
}

variable "applistener_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTPS"
}

variable "dblb_name" {
  description = "Name - ALB"
  default     = "dblb"
}

variable "dbtg_name" {
  description = "Name - ALB TG"
  default     = "dblb-tg"
}

variable "dbtg_port" {
  description = "Enter the port - ALB TG"
  default     = "80"
}

variable "dbtg_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTP"
}

variable "dblistener_port" {
  description = "Enter the port - ALB TG"
  default     = "443"
}

variable "dblistener_protocol" {
  description = "Enter the protocol - ALB TG"
  default     = "HTTPS"
}

variable "certificate_arn_user" {
  description = "Enter the cert ARN for HTTPS"
  default     = "#########"
}
