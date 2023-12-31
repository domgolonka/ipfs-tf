data "aws_availability_zones" "blockparty" {
  state = "available"
}


resource "aws_eip" "nat_gateway_eip" {
  count  = var.private_cidrs != null ? (var.use_one_nat_gateway ? 1 : length(var.private_cidrs)) : 0
  domain = "vpc"

  tags = {
    Name = "${var.project}-${var.env}-nat-gateway-eip-${substr(data.aws_availability_zones.blockparty.names[count.index], -2, -1)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.private_cidrs != null ? (var.use_one_nat_gateway ? 1 : length(var.private_cidrs)) : 0

  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.project}-${var.env}-nat-gateway-${substr(data.aws_availability_zones.blockparty.names[count.index], -2, -1)}"
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_eip.nat_gateway_eip]
}

# Internet gateway for public subnet
resource "aws_internet_gateway" "blockparty" {
  vpc_id = aws_vpc.blockparty.id

  tags = {
    Name = "${var.project}-${var.env}-internet-gateway"
  }
}