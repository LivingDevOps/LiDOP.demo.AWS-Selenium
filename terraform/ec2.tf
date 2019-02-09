resource "aws_instance" "vpn" {
  connection {
    user = "ubuntu"
    private_key = "${file("${var.private_key}")}"
  }
  instance_type = "t2.micro"
  ami = "ami-0c6e204396d55eeec"
  key_name = "${var.private_key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_demo.id}"]
  subnet_id = "${aws_subnet.default1.id}"
  source_dest_check = false
  private_ip = "172.10.10.10"

  provisioner "file" {
    source      = "."
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo bash /tmp/OpenVpn/install.sh",
      "sudo /usr/local/openvpn_as/bin/sqlite3 /usr/local/openvpn_as/etc/db/config.db \"INSERT INTO config VALUES(1,'host.name','${aws_instance.vpn.public_ip}');\""
    ]
  }

  tags = { 
    Name = "vpn-server"
  }
}

resource "aws_instance" "chrome" {
  connection {
    user = "ubuntu"
    private_key = "${file("${var.private_key}")}"
  }
  
  count = "${var.count}"

  instance_type = "t2.nano"
  ami = "ami-0c6e204396d55eeec"
  key_name = "${var.private_key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_demo.id}"]
  subnet_id = "${aws_subnet.default1.id}"


  provisioner "file" {
    source      = "./Docker"
    destination = "/tmp/Docker"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo bash /tmp/Docker/install.sh",
      "sudo sudo ip route add 10.20.30.0/24 via 172.10.10.10 dev eth0",
      "sudo docker run -d -e HUB_HOST=10.20.30.40 -e HUB_PORT=8091 -e REMOTE_HOST=http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):5555 --net=host selenium/node-chrome"
    ]
  }

  tags = { 
    Name = "chrome-client"
  }
}

resource "aws_instance" "firefox" {
  connection {
    user = "ubuntu"
    private_key = "${file("${var.private_key}")}"
  }
  
  count = "${var.count}"

  instance_type = "t2.nano"
  ami = "ami-0c6e204396d55eeec"
  key_name = "${var.private_key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_demo.id}"]
  subnet_id = "${aws_subnet.default1.id}"


  provisioner "file" {
    source      = "./Docker"
    destination = "/tmp/Docker"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo bash /tmp/Docker/install.sh",
      "sudo sudo ip route add 10.20.30.0/24 via 172.10.10.10 dev eth0",
      "sudo docker run -d -e HUB_HOST=10.20.30.40 -e HUB_PORT=8091 -e REMOTE_HOST=http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):5555 --net=host selenium/node-firefox"
    ]
  }

  tags = { 
    Name = "firefox-client"
  }
}