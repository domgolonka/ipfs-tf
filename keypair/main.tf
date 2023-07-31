resource "aws_key_pair" "blockparty" {
  key_name   = "${var.project}-${var.env}-${var.name}"
  public_key = var.public_key
}