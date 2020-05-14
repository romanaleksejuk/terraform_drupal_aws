resource "aws_vpc" "drupal-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "drupal-vpc-${var.environment}"
    }
}


resource "aws_subnet" "drup-public-1" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "drup-public-1-${var.environment}"
    }
}
resource "aws_subnet" "drup-public-2" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1b"

    tags = {
        Name = "drup-public-2-${var.environment}"
    }
}
resource "aws_subnet" "drup-public-3" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-central-1c"

    tags = {
        Name = "drup-public-3-${var.environment}"
    }
}
resource "aws_subnet" "drup-private-1" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "drup-private-1-${var.environment}"
    }
}
resource "aws_subnet" "drup-private-2" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1b"

    tags = {
        Name = "drup-private-2-${var.environment}"
    }
}
resource "aws_subnet" "drup-private-3" {
    vpc_id = aws_vpc.drupal-vpc.id
    cidr_block = "10.0.6.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-central-1c"

    tags  = {
        Name = "drup-private-3-${var.environment}"
    }
}

resource "aws_internet_gateway" "drup-igw" {
    vpc_id = aws_vpc.drupal-vpc.id

    tags = {
        Name = "drup-igw-${var.environment}"
    }
}

resource "aws_route_table" "drup-public" {
    vpc_id = aws_vpc.drupal-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.drup-igw.id
    }

    tags = {
        Name = "drup-public-1-${var.environment}"
    }
}

resource "aws_route_table_association" "drup-public-1-a" {
    subnet_id = aws_subnet.drup-public-1.id
    route_table_id = aws_route_table.drup-public.id
}
resource "aws_route_table_association" "drup-public-2-a" {
    subnet_id = aws_subnet.drup-public-2.id
    route_table_id = aws_route_table.drup-public.id
}
resource "aws_route_table_association" "drup-public-3-a" {
    subnet_id = aws_subnet.drup-public-3.id
    route_table_id = aws_route_table.drup-public.id
}
resource "aws_route_table" "drup-private" {
    vpc_id = aws_vpc.drupal-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat-gw.id
    }

    tags = {
        Name = "drup-private-1-${var.environment}"
    }
}
resource "aws_route_table_association" "drup-private-1-a" {
    subnet_id = aws_subnet.drup-private-1.id
    route_table_id = aws_route_table.drup-private.id
}
resource "aws_route_table_association" "drup-private-2-a" {
    subnet_id = aws_subnet.drup-private-2.id
    route_table_id = aws_route_table.drup-private.id
}
resource "aws_route_table_association" "drup-private-3-a" {
    subnet_id = aws_subnet.drup-private-3.id
    route_table_id = aws_route_table.drup-private.id
}

resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.drup-public-1.id
  depends_on = [aws_internet_gateway.drup-igw]
}
