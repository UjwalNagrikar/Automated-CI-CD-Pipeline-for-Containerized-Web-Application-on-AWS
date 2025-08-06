resource "aws_instance" "my-server" {
    ami = "ami-0f918f7e67a3323f0"
    key_name = "Ujwal-SRE"
    subnet_id = aws_subnet.public[0].id
    instance_type = "t2.midium"
    vpc_security_group_ids = [aws_security_group.ecs_tasks.id]
    tags = {
      Name = "MyServer"
    }

    user_data = <<-EOF
    #!/bin/bash
    apt update -y

    # Install Docker
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker

    # Install unzip and wget
    apt install -y unzip wget

    # Download and unzip portfolio
    cd /home/ubuntu
    wget https://github.com/UjwalNagrikar/Automated-CI-CD-Pipeline-for-Containerized-Web-Application-on-AWS.git/archive/refs/heads/main.zip -O main.zip
    unzip main.zip
    chown -R ubuntu:ubuntu /home/ubuntu/
    cd Ujwal-Portfolio-main

    # Build and run Docker container
    echo "Building Docker image..."
    docker build -t ujwal-portfolio .

    echo "Running Docker container..."
    docker run -d -p 80:80 --name ujwal-ci-cd ujwal-cii-cd 
    EOF
}