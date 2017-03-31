## Variables

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "key_name" {}

variable "cidr_prefix" {
  default = "10.10"
}

variable "dns_zone" {}

variable "ami_type" {
  type = "map"

  default = {
    eu-west-1    = "ami-52d1fe34"
    eu-west-2    = "ami-8ac7d2ee"
    eu-central-1 = "ami-9ccd18f3"
  }
}

variable "env_name" {
  default = "rancher"
}

variable "srv_size" {
  default = "t2.medium"
}

variable "hst_size" {
  default = "t2.small"
}

variable "hst_max" {
  default = "0"
}

variable "hst_min" {
  default = "0"
}

variable "hst_des" {
  default = "0"
}

variable "reg_token" {
  default = "123567890abcde.edcba0987654321.1234567890abcde"
}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_class" {}
variable "db_storage" {}
variable "db_backup_retention" {}
variable "db_multi_az" {}
variable "db_final_snapshot" {
  default = "true"
}

variable "rancher_admin_name" {}
variable "rancher_admin_username" {}
variable "rancher_admin_password" {}
