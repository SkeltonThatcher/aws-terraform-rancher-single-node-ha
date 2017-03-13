## Variables

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "eu-west-1"
}
variable "key_pair" {}

variable "cidr_prefix" {
  default = "10.10"
}

variable "dns_zone" {}

variable "ami_type" {
  type = "map"
  default = {
    eu-west-1    = "ami-de90bdb8"
    eu-west-2    = "ami-9bd6c3ff"
    eu-central-1 = "ami-835a90ec"
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
variable "hst_max" {}
variable "hst_min" {}
variable "hst_des" {}
variable "reg_token" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "db_class" {}
variable "db_storage" {}
variable "db_backup_retention" {}
variable "db_multi_az" {}

variable "rancher_admin_name" {}
variable "rancher_admin_username" {}
variable "rancher_admin_password" {}
