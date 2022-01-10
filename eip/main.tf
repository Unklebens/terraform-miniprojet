
resource "aws_eip" "fahim-eIP" {
  vpc      = true
  tags = {
    "Name" = var.eipname
  }
}

output "eip-alloc" {
  value = aws_eip.fahim-eIP.allocation_id
}

output "eip-addr" {
  value = aws_eip.fahim-eIP.public_ip
}