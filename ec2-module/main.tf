resource "aws_instance" "myserver1" {
  ami           = "ami-02f3416038bdb17fb"
  instance_type = var.instance_type
  key_name = "bestkey"
  tags = {
    Name = "Jenkins-EC2"
  }
}