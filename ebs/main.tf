resource "aws_ebs_volume" "ebs" {
  availability_zone = "us-west-2a"
  size              = var.ebssize
  tags = {
    Name = "${var.admin}-vol"
  }
}

output "ebs_id" {
  value = aws_ebs_volume.ebs.id
}