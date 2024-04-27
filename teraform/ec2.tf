module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.security-group.id]
  key_name               = "jadhav_cred"
  subnet_id              = module.vpc.public_subnets[0]
  root_block_device = [
    {
      volume_size = 30
    }
  ]

  user_data = templatefile("./script.sh", {})

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_security_group" "security-group" {
  
  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress = [
    for port in [22,443 , 8080, 9000, 9090, 80] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.sg-name"
  }
}