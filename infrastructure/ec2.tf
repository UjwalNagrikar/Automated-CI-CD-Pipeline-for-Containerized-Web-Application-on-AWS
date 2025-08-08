# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

# Private Subnets (No internet)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Public Subnet Route Table Association
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# EC2 Instance
resource "aws_instance" "my_server" {
  ami                    = "ami-0f58b397bc5c1f2e8"  # Updated Ubuntu 22.04 LTS for ap-south-1
  key_name              = "Ujwal-SRE"
  subnet_id             = aws_subnet.public[0].id
  instance_type         = "t2.medium"  # Fixed typo: was "t2.midium"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Create separate SG
  
  tags = {
    Name = "${var.project_name}-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    #!/bin/bash

set -e

# Update system
echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Java (required for Jenkins)
echo "[+] Installing Java..."
sudo apt install openjdk-11-jdk -y

# Install Jenkins
echo "[+] Installing Jenkins..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update
sudo apt install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Docker
echo "[+] Installing Docker..."
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

sudo apt update
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker

# Add Jenkins to Docker group
echo "[+] Adding Jenkins to Docker group..."
sudo usermod -aG docker jenkins

# Install AWS CLI
echo "[+] Installing AWS CLI..."
sudo apt install awscli -y

echo "✅ Jenkins, Docker, Java, and AWS CLI installation complete!"
echo "👉 Access Jenkins at: http://<your-server-ip>:8080"

  EOF
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-"
  vpc_id      = aws_vpc.main.id

  # Allow all inbound traffic
  ingress {
    description = "Allow all inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}