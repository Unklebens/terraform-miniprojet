


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "my-ec2" {
  availability_zone = "us-west-2a"
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.size
  key_name          = var.kp
  security_groups   = ["${var.sg_name}"]
  user_data         = <<-EOF
#!/bin/bash
sleep 10
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
EOF
  tags = {
    "Name" = var.tag
  }
  root_block_device {
    delete_on_termination = true
  }
}


output "ec2id" {
  value = aws_instance.my-ec2.id
}