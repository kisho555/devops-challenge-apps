provider "aws" {
  region = "us-east-1"  
}

resource "aws_instance" "example_vm" {
  ami           = "ami-04b70fa74e45c3917"  
  instance_type = "t2.micro"  # Specify the instance type

  tags = {
    Name = "ExampleVM"
  }
  
  # Example: Configure SSH key for access
  key_name      = "ki"
  security_groups = ["default"]  # Ensure this security group allows SSH access

  # Example: Optional user_data for initial setup (like installing Docker, etc.)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              EOF
}
