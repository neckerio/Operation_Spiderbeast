output "vpc_main_id" {
    value = aws_vpc.main.id
    description = "The main VPC IDof Operation Spiderbeast"
  }

  output "subnet_main_id" {
    value = aws_subnet.main.id
    description = "The main SUBNET ID of Operation Spiderbeast"
  }

