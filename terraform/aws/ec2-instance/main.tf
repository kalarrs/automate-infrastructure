locals {
  stage = lookup(var.tags, "Stage", null)
  name  = "${var.name}-${local.stage}"
}

module "ec2_instance" {
  source  = "registry.terraform.io/terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = local.name

  // Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type - ami-00ee4df451840fa9d (64-bit x86) / ami-0cde3ffbd04841819 (64-bit Arm)
  ami                    = "ami-0cde3ffbd04841819"
  instance_type          = "a1.medium"
  #  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = var.vpc_security_group_ids
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id

  tags = var.tags
}
