###   Terraform support version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

###   Gather Region Info
provider "aws" {
  region  = "${var.region}"
}

###   Collect AZs
data "aws_availability_zones" "available" {
  state = "available"
}

###   VPC with mentioned CIDR block
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

###   Create Web Subnet
resource "aws_subnet" "web" {
  count             = "${length(var.web_subnets_cidr_blocks)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${var.web_subnets_cidr_blocks[count.index]}"

  tags = {
    Name = "web-public-${count.index}"
  }

}

###   Create App Subnet
resource "aws_subnet" "app" {
  count             = "${length(var.app_subnets_cidr_blocks)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${var.app_subnets_cidr_blocks[count.index]}"

  tags = {
    Name = "app-private-${count.index}"
  }

}

###   Create DB Subnet
resource "aws_subnet" "db" {
  count             = "${length(var.public_subnets_cidr_blocks)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${var.db_subnets_cidr_blocks[count.index]}"

  tags = {
    Name = "db-private-${count.index}"
  }

}

###   Create Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

###   Create public Subnet for IG, NAT-G
resource "aws_subnet" "public" {
  count             = "${length(var.public_subnets_cidr_blocks)}"
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${var.public_subnets_cidr_blocks[count.index]}"

  tags = {
    Name = "dmz-public-${count.index}"
  }
}

###   Create Routing Table for DMZ
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

###   Create Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "Nat Gateway IP"
  }
}

###   Create an NAT gateway to give our private subnets access to Internet
resource "aws_nat_gateway" "default" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, 0)}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

###   Create Route tables for Web Tier
resource "aws_route_table" "web" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Web"
  }
}

resource "aws_route_table_association" "web" {
  count          = "${length(var.web_subnets_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.web.*.id, count.index)}"
  route_table_id = "${aws_route_table.web.id}"
}

###   Create Route tables for App Tier
resource "aws_route_table" "app" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.default.id}"
  }

  tags = {
    Name = "App"
  }
}

resource "aws_route_table_association" "app" {
  count          = "${length(var.app_subnets_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${aws_route_table.app.id}"
}


###   Create Subnet group for DB
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.rds_subnet_name}"
  subnet_ids = flatten(["${aws_subnet.db.*.id}"])

  tags = {
    Name = "${var.rds_subnet_name}"
  }
}

###   Create RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = "${var.rds_storage}"
  engine               = "${var.rds_engine}"
  instance_class       = "${var.rds_instance_class}"
  name                 = "${var.rds_name}"
  username             = "${var.rds_username}"
  password             = "${var.rds_password}"
  db_subnet_group_name = "${var.rds_subnet_name}"
  depends_on = [aws_db_subnet_group.rds_subnet_group]
}

###   Create Route tables for DB Tier
resource "aws_route_table" "db" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "DB"
  }
}

resource "aws_route_table_association" "db" {
  count          = "${length(var.db_subnets_cidr_blocks)}"
  subnet_id      = "${element(aws_subnet.db.*.id, count.index)}"
  route_table_id = "${aws_route_table.db.id}"
}

###   Create SG for DB Tier
resource "aws_security_group" "dbserver_sg" {
  name        = "allow_rds"
  description = "Allow rds inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.dbsg_name}"
  }
}

###   Create SG for Web Tier
resource "aws_security_group" "webserver_sg" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.websg_name}"
  }
}

###   Create EC2 instances for Web Tier
resource "aws_instance" "webservers" {
  count           = "${length(var.web_subnets_cidr_blocks)}"
  ami             = "${var.web_ami}"
  instance_type   = "${var.web_instance}"
  security_groups = ["${aws_security_group.webserver_sg.id}"]
  subnet_id       = "${element(aws_subnet.web.*.id,count.index)}"

  tags = {
    Name = "${element(var.webserver_name,count.index)}"
  }
}

###   Create SG for App Tier
resource "aws_security_group" "appserver_sg" {
  name        = "appallow_http"
  description = "Allow http inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/23"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.websg_name}"
  }
}

###   Create EC2 instances for App Tier
resource "aws_instance" "appservers" {
  count           = "${length(var.app_subnets_cidr_blocks)}"
  ami             = "${var.app_ami}"
  instance_type   = "${var.app_instance}"
  security_groups = ["${aws_security_group.appserver_sg.id}"]
  subnet_id       = "${element(aws_subnet.app.*.id,count.index)}"

  tags = {
    Name = "${element(var.appserver_name,count.index)}"
  }
}

###   Create ALB
resource "aws_lb" "weblb" {
  name               = "${var.lb_name}"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.webserver_sg.id}"]
  subnets            = flatten(["${aws_subnet.web.*.id}"])

  tags = {
    Name = "${var.lb_name}"
  }
}

###   Create ALB TG
resource "aws_lb_target_group" "alb_group" {
  name     = "${var.tg_name}"
  port     = "${var.tg_port}"
  protocol = "${var.tg_protocol}"
  vpc_id   = "${aws_vpc.default.id}"
}

###   Create Listeners for LB
resource "aws_lb_listener" "webserver-lb" {
  load_balancer_arn = "${aws_lb.weblb.arn}"
  port              = "${var.listener_port}"
  protocol          = "${var.listener_protocol}"
  certificate_arn  = "${var.certificate_arn_user}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_group.arn}"
    type             = "forward"
  }
}

###   Creating Listener rules
resource "aws_lb_listener_rule" "allow_all" {
  listener_arn = "${aws_lb_listener.webserver-lb.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_group.arn}"
  }

  condition {
    host_header {
      values = ["3tier-challenge-example.com"]
    }
  }
}

###   Create ALB
resource "aws_lb" "applb" {
  name               = "${var.applb_name}"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.appserver_sg.id}"]
  subnets            = flatten(["${aws_subnet.app.*.id}"])

  tags = {
    Name = "${var.applb_name}"
  }
}

###   Create ALB TG
resource "aws_lb_target_group" "appalb_group" {
  name     = "${var.apptg_name}"
  port     = "${var.apptg_port}"
  protocol = "${var.apptg_protocol}"
  vpc_id   = "${aws_vpc.default.id}"
}

###   Create Listeners for LB
resource "aws_lb_listener" "appserver-lb" {
  load_balancer_arn = "${aws_lb.applb.arn}"
  port              = "${var.listener_port}"
  protocol          = "${var.listener_protocol}"
  certificate_arn  = "${var.certificate_arn_user}"

  default_action {
    target_group_arn = "${aws_lb_target_group.appalb_group.arn}"
    type             = "forward"
  }
}

###   Creating Listener rules
resource "aws_lb_listener_rule" "appallow_all" {
  listener_arn = "${aws_lb_listener.appserver-lb.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_group.arn}"
  }

  condition {
    host_header {
      values = ["/static/*"]
    }
  }
}

###   Create ALB
resource "aws_lb" "dblb" {
  name               = "${var.dblb_name}"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.dbserver_sg.id}"]
  subnets            = flatten(["${aws_subnet.db.*.id}"])

  tags = {
    Name = "${var.dblb_name}"
  }
}

###   Create ALB TG
resource "aws_lb_target_group" "dbalb_group" {
  name     = "${var.dbtg_name}"
  port     = "${var.dbtg_port}"
  protocol = "${var.dbtg_protocol}"
  vpc_id   = "${aws_vpc.default.id}"
}

###   Create Listeners for LB
resource "aws_lb_listener" "dbserver-lb" {
  load_balancer_arn = "${aws_lb.dblb.arn}"
  port              = "${var.listener_port}"
  protocol          = "${var.listener_protocol}"
  certificate_arn  = "${var.certificate_arn_user}"

  default_action {
    target_group_arn = "${aws_lb_target_group.dbalb_group.arn}"
    type             = "forward"
  }
}

###   Creating Listener rules
resource "aws_lb_listener_rule" "dballow_all" {
  listener_arn = "${aws_lb_listener.dbserver-lb.arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.alb_group.arn}"
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-For"
      values           = ["10.*.*.*"]
    }
  }
}

###   DNS Registration 
data "aws_route53_zone" "mydomain" {
  name = "3tier-challenge-example.com"
}

resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = var.dns_name 
  type    = "A"
  alias {
    name                   = aws_lb.weblb.name
    # zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }  
}