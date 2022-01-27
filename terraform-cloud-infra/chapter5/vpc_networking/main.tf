provider "aws" {
  region = var.region
}

resource "aws_vpc" "module_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "Production-VPS"
  }
}

# Public and Private Subnets
resource "aws_subnet" "module_public_subnet_1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "module_public_subnet_2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "module_public_subnet_3" {
  cidr_block        = var.public_subnet_3_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Public-Subnet-3"
  }
}

resource "aws_subnet" "module_private_subnet_1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "module_private_subnet_2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

resource "aws_subnet" "module_private_subnet_3" {
  cidr_block        = var.private_subnet_3_cidr
  vpc_id            = aws_vpc.module_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Private-Subnet-3"
  }
}

# Route Table for Public & Private Routes
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name = "Public-Route-Table"
  }
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.module_vpc.id

  tags = {
    Name = "Private-Route-Table"
  }
}

# Associate Routetables with respective subnets
resource "aws_route_table_association" "public_subnet_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.module_public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.module_public_subnet_2.id
}

resource "aws_route_table_association" "public_subnet_3_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.module_public_subnet_3.id
}


resource "aws_route_table_association" "private_subnet_1_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.module_private_subnet_1.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.module_private_subnet_2.id
}
resource "aws_route_table_association" "private_subnet_3_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id = aws_subnet.module_private_subnet_3.id
}


# CREATING AN ELASTIC IP FOR NAT GATEWAY
resource "aws_eip" "elastic_ip_for_nat_gw" {
  vpc = true
  associate_with_private_ip = var.eip_association_address
  
  tags = {
    Name = "Production-EIP"
  }
}

# CREATING A NAT GATEWAY AND ADDING IT TO ROUTE TABLE
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip_for_nat_gw.id
  subnet_id = aws_subnet.module_public_subnet_1.id

  tags = {
    Name = "Production-NAT-GW"
  }
}
# Add route for the nat gateway
resource "aws_route" "nat_gateway_route" {
  route_table_id = aws_route_table.private_route_table.id
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# CREATING AN INTERNET GATEWAY & ADDING TO ROUTE TABLE 
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.module_vpc.id
  tags = {
    Name = "Production-IGW"
  }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"

}

# IMPLEMENTING EC2 ON TOP OF SETUP
data "aws_ami" "ubuntu" {
  owners = ["099720109477"]
  most_recent = true

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# generate key using: aws ec2 create-key-pair --key-name my-first-ec2-instance --region us-east-2 query "KeyMaterial" --output text > my-first-ec2-instance.pem
resource "aws_security_group" "ec2-security-group" {
  name = "EC2-Instance-SG"
  vpc_id = aws_vpc.module_vpc.id
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-first-ec2-instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name = var.ec2_keypair
  security_groups = [aws_security_group.ec2-security-group.id]
  subnet_id=aws_subnet.module_public_subnet_1.id

}

output "vpc_cidr" {
  value = aws_vpc.module_vpc.cidr_block
}

output "public_subnet_1_cidr" {
  value = aws_subnet.module_public_subnet_1.cidr_block
}

# output "public_subnet_2_cidr" {
#   value = aws_subnet.module_public_subnet_2.cidr_block
# }

# output "public_subnet_3_cidr" {
#   value = aws_subnet.module_public_subnet_3.cidr_block
# }

output "private_subnet_1_cidr" {
  value = aws_subnet.module_private_subnet_1.cidr_block
}

# output "private_subnet_2_cidr" {
#   value = aws_subnet.module_private_subnet_2.cidr_block
# }

# output "private_subnet_3_cidr" {
#   value = aws_subnet.module_private_subnet_3.cidr_block
# }