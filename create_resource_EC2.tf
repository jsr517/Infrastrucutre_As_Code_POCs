
provider "aws" {
  region     = "us-east-1"
  access_key = "MyAccessKey"
  secret_key = "MySecretKey"
}

resource "aws_instance" "dev_server" {
  ami =  "ami-085925f297f89fce1"
  instance_type = "t2.micro"

  tags = {
    Name = "DevServer"
  }
}
