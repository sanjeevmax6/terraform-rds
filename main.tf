terraform {
  backend "s3" {
    bucket         = "terraform-rds-state"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}

# Provider Configuration
# Specifies the AWS provider and region for Terraform to manage resources in.
provider "aws" {
  region = "us-east-1"
}

# EC2 Instance
# Launches an EC2 instance for WordPress and sets up user data.

# WordPress EC2 Instance
resource "aws_instance" "wordpress_ec2" {
  ami                    = data.aws_ami.amazon_linux_2023.id  # Use the AMI we filtered above
  instance_type          = "t2.micro"  # Free tier eligible instance type
  subnet_id              = aws_subnet.public_subnet.id  # Place in the public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Attach the EC2 security group
  key_name               = "SANJEEV_USEAST1_KEY"  # Replace with your SSH key pair name

  # TODO: Pass in the 4 variables to the user data script
user_data = templatefile("${path.module}/wp_rds_install.tpl", {
    db_name     = aws_db_instance.wordpress_db.db_name
    db_username = var.username_db
    db_password = var.password_db
    db_endpoint = aws_db_instance.wordpress_db.endpoint
})

  tags = {
    Name = "WordPress EC2 Instance"
  }
}