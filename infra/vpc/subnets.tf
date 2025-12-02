resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet("10.0.0.0/24", 4, count.index)
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  tags = {
    Name = "public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count      = 2
  cidr_block = cidrsubnet("10.0.1.0/24", 4, count.index + 2)
  vpc_id     = aws_vpc.main.id

  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  tags = {
    Name = "private-${count.index}"
  }
}





