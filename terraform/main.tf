provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  backend "consul" {
    address = "10.20.30.40:8500"
    scheme  = "http"
    path    = "aws-demo"
    lock    = false
  }
}

output "vpn_ip" {
  value = "${aws_instance.vpn.public_ip}"
}
