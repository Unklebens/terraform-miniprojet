module "sege" {
  source = "../sg"
  admin  = "fahim-miniprojet"
}

module "stockage" {
  source = "../ebs"
  admin  = "fahim-miniprojet"
}

module "ec2module" {
  source = "../ec2"
  size   = "t2.micro"
  sg_name = "${module.sege.sg_out}"
  kp="fahim-kp-oregon"
  tag="fahim-ec2-miniprojet"
}

module "elasticip" {
  source  = "../eip"
  eipname = "fahim-miniprojet"
  ec2id   = module.ec2module.ec2id
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2module.ec2id
  allocation_id = module.elasticip.eip-alloc
}

resource "local_file" "export_info" {
 filename = "../ip_ec2.txt" 
 content = "L'ip de la machine deployée par Terraform est ${module.elasticip.eip-addr}"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.stockage.ebs_id
  instance_id = module.ec2module.ec2id
}




terraform {
  backend "s3" {
    bucket                  = "fahim-bicket-ajc"
    key                     = "miniprojet-prod.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "R:/Formation/AJC/terraform/credentials"
  }
}

