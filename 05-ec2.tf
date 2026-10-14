data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  ami           = coalesce(var.instance_config.ami_id, data.aws_ami.amazon_linux.id)
  instance_type = var.instance_config.instance_type

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  associate_public_ip_address = var.subnet_config.publica

  root_block_device {
    volume_size           = var.instance_config.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.instance_config.tags, {
    Name = "ec2"
  })
}
