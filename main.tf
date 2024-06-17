# Define provider (AWS)
provider "aws" {
  region = "us-east-1"  # Specify your preferred region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create subnets
resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Adjust AZ as needed
}

resource "aws_subnet" "api" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Adjust AZ as needed
}

# Create security groups
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  # Inbound rules for web app
  # Example: HTTP inbound from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "api_sg" {
  vpc_id = aws_vpc.main.id

  # Inbound rules for API
  # Example: HTTP inbound from anywhere
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch configurations for EC2 instances (web app and API)
resource "aws_instance" "web_instance" {
  ami           = "ami-04b70fa74e45c3917"  
  subnet_id     = aws_subnet.web.id
  security_groups = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    # Docker installation and container startup script
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d -p 3000:3000 <your-web-app-image>
  EOF
}

resource "aws_instance" "api_instance" {
  ami           = "ami-04b70fa74e45c3917"  # Specify appropriate AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.api.id
  security_groups = [aws_security_group.api_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    # Docker installation and container startup script
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo docker run -d -p 5000:5000 <webapp/Dockerfile>
  EOF
}

# Output the public IP addresses or DNS names of instances
output "web_instance_public_ip" {
  value = aws_instance.web_instance.public_ip
}

output "api_instance_public_ip" {
  value = aws_instance.api_instance.public_ip
}
