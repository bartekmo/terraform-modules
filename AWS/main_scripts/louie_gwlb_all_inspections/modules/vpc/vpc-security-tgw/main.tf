resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-igw"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet2"
  }
}

resource "aws_subnet" "gwlb_subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.gwlb_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-gwlb-subnet1"
  }
}

resource "aws_subnet" "gwlb_subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.gwlb_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-gwlb-subnet2"
  }
}

resource "aws_subnet" "tgwattach_subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.tgwattach_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgwattach-subnet1"
  }
}

resource "aws_subnet" "tgwattach_subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.tgwattach_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgwattach-subnet2"
  }
}

resource "aws_vpc_endpoint" "gwlb_endpoint_az1" {
  service_name      = var.gwlb_endpoint_service_name
  subnet_ids        = [aws_subnet.gwlb_subnet1.id]
  vpc_endpoint_type = var.gwlb_endpoint_service_type
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-gwlbe-az1"
  }
}

resource "aws_vpc_endpoint" "gwlb_endpoint_az2" {
  service_name      = var.gwlb_endpoint_service_name
  subnet_ids        = [aws_subnet.gwlb_subnet2.id]
  vpc_endpoint_type = var.gwlb_endpoint_service_type
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-gwlbe-az2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-rt"
  }
}

resource "aws_route_table" "gwlb_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
	transit_gateway_id = var.transit_gateway_id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-gwlb-rt"
  }
}

resource "aws_route_table" "tgwattach1_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
	vpc_endpoint_id = aws_vpc_endpoint.gwlb_endpoint_az1.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgwattach1-rt"
  }
}

resource "aws_route_table" "tgwattach2_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
	vpc_endpoint_id = aws_vpc_endpoint.gwlb_endpoint_az2.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgwattach2-rt"
  }
}


resource "aws_route_table_association" "public_rt_association1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "gwlb_rt_association1" {
  subnet_id = aws_subnet.gwlb_subnet1.id
  route_table_id = aws_route_table.gwlb_rt.id
}

resource "aws_route_table_association" "gwlb_rt_association2" {
  subnet_id = aws_subnet.gwlb_subnet2.id
  route_table_id = aws_route_table.gwlb_rt.id
}

resource "aws_route_table_association" "tgwattach_rt_association1" {
  subnet_id = aws_subnet.tgwattach_subnet1.id
  route_table_id = aws_route_table.tgwattach1_rt.id
}

resource "aws_route_table_association" "tgwattach_rt_association2" {
  subnet_id = aws_subnet.tgwattach_subnet2.id
  route_table_id = aws_route_table.tgwattach2_rt.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids = [aws_subnet.tgwattach_subnet1.id, aws_subnet.tgwattach_subnet2.id]
  transit_gateway_id = var.transit_gateway_id
  vpc_id = aws_vpc.vpc.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  appliance_mode_support = "enable"
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgw-attach"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.tgw_security_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_propagation" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.tgw_spoke_route_table_id
}

resource "aws_ec2_transit_gateway_route" "tgw_defaultroute" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.tgw_spoke_route_table_id
}
