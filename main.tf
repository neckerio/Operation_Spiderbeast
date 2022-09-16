# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_main"
  }
}

# Create a subnet 
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_subnet_main"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
  }
}

# Create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name      = "public_rtb"
  }
}

# Create SSH security group
resource "aws_security_group" "ingress_ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create Ping security group
resource "aws_security_group" "ping" {
  name        = "ping"
  vpc_id      = aws_vpc.main.id
  description = "ICMP for Ping Access"
  ingress {
    description = "Allow ICMP Traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = -1
    to_port     = -1
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create route table associations
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.main.id
}


# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

# Terraform Data Block - Lookup aws_ami
data "aws_ami" "rhel_8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"]
  }
}

# Reference aws_ami in an output
output "aws_ami_name_search" {
  value = data.aws_ami.rhel_8.id
}

# Reference aws_region in an output
output "aws_region_current" {
  value = data.aws_region.current.id
}

# Reference aws_availability_zones in an output
output "aws_availability_zones" {
  value = data.aws_availability_zones.available.id
}



### WARNING:
### The below private/public key creation is used only for quickly spinning up and destroying 
### EC2 instances. It isn't recommended for production.

# Create TLS key
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Derive local file from TLS key
resource "local_sensitive_file" "private_key_pem" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = "AWSKey.pem"
  file_permission = "600"
  directory_permission = "700"
}

# Use localfile for aws key pair
resource "aws_key_pair" "generated" {
  key_name   = "AWSKey.pem"
  public_key = tls_private_key.rsa_4096.public_key_openssh
}
### WARNING end.


# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.rhel_8.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ingress_ssh.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name

  connection {
    user        = "necker"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  tags = {
    Name      = "RHEL-8"
    Owner     = "necker"
    App       = "D&D"
    Service   = "Devops"
    CreatedBy = "necker"
  }

}

# Output the aws_instances ip
output "aws_instance_public_ip" {
 value = aws_instance.web_server.public_ip
 }

