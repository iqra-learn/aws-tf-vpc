
#create VPC

resource "aws_vpc" "my-VPC" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

    tags = {

        name = "${var.project_name}-${var.Environment}-vpc"
        }
}
# create Internet Gateway for VPC

resource "aws_internet_gateway" "internet_gateway" {

    vpc_id = aws_vpc.my_vpc.id 

    tags = {
      Name = "${var.project_name}-${var.Environment}-igw"
    }
  
}

# Use All the available AZ in region

data "aws_availability_zones" "available_zones" {
  
}

# Create Public Subnet az1

resource "aws_subnet" "public_subnet_az1" {
vpc_id = aws_vpc.my_vpc.id 
cidr_block = var.public_subnet_az1_cidr
availability_zone = data.aws_availability_zones.available_zones.Names[0]
map_public_ip_on_launch = true

 tags = {
    Name = "${var.project_name}-${var.Environment}-public_subnet_az1"
  }

}

# Create Public Subnet az2

resource "aws_subnet" "public_subnet_az2" {
vpc_id = aws_vpc.my_vpc.id 
cidr_block = var.public_subnet_az2_cidr
availability_zone = data.aws_availability_zones.available_zones.Names[1]
map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.Environment}-public_subnet_az2"
  }

}

# Create Route Table and add public route

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my-VPC.id

  route = {

     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id

    tags = {
      Name = "${var.project_name}-${var.Environment}-public_route"
    }

  }
}

# associate public subnet az1 to purblic route table

resource "aws_route_table_association" "public_route_table_association_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route.id
  }

# associate public subnet az2 to purblic route table

resource "aws_route_table_association" "public_route_table_association_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route.id
  }

  # create private subnet az1

    resource "aws_subnet" "private_subnet_az1" {
      vpc_id = aws_vpc.my_vpc.id
      cidr_block = var.private_subnet_az1_cidr
      availability_zone = data.aws_availability_zones.available_zones.Names[0]
      map_public_ip_on_launch = false
      tags = {
        Name = "${var.project_name}-${var.Environment}-private_subnet_az1"
        }
        }

# create private subnet az2

 resource "aws_subnet" "private_subnet_az2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.Names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-${var.Environment}-private_subnet_az2"
    }
    }

    # create private data subnet az1
    resource "aws_subnet" "private_data_subnet_az1" {
      vpc_id = aws_vpc.my_vpc.id
      cidr_block = var.private_data_subnet_az1_cidr
      availability_zone = data.aws_availability_zones.available_zones.Names[0]
      map_public_ip_on_launch = false
      tags = {
        Name = "${var.project_name}-${var.Environment}-private_data_subnet_az1"
        }
        }

# Create private data subnet az2
  resource "aws_subnet" "private_data_subnet_az2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_data_subnet_az2_cidr
    availability_zone = data.aws_availability_zones.available_zones.Names[1]
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.project_name}-${var.Environment}-private_data_subnet_az2"
      }
      }
      

