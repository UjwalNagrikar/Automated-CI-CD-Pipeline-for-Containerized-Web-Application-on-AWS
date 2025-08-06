resource "aws_instance" "my-server" {
    ami = "ami-0f918f7e67a3323f0"
    key_name = "Ujwal-SRE"
    subnet_id = aws_subnet.public[0].id
    instance_type = "t2.midium"
    vpc_security_group_ids = [aws_security_group.ecs_tasks.id]
    tags = {
      Name = "MyServer"
    }
}