variable "asw_key_pair" {
  default = "path to .pem file"
}

provider "aws" {     // Chosse cloud provider as AWS
  region = "us-east-1"
}

resource "aws_security_group" "web_server_sg" {
  name   = "web_server_sg"
  vpc_id = "vpc-d6a4d03e"  // Please check vpc id 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1 // -1 signifies all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "web_server_sg"
  }

}

resource "aws_instance" "web_server" {
  ami                    = "ami-026b57f3c383c2eec"
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  subnet_id              = "subnet-aafd6be7"



  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.asw_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Welcome to JSR517 - Server IP is ${self.public_dns} | sudo tee /var/www/html/index.html"

    ]

  }

}
