resource "aws_instance" "ec2" {
  for_each = {
    for key, value in var.ec2_config :
    key => value
  }
  instance_type = each.value.instance_type
  ami           = data.aws_ami_windows_image.id
}

data "aws_ami" "windows_image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "platform"
    values = ["windows"]
  }
  owners = ["amazon"]
}
