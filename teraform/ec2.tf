module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  monitoring             = true
  vpc_security_group_ids = module.vote_service_sg.security_group_id
  key_name               = "jadhav_cred"
  subnet_id              = module.vpc.public_subnets
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


module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  description = "Allowing Jenkins, Sonarqube, SSH Access"

  ingress_rules = [
    for port in [22, 443, 8080, 9000, 9090, 80] : {
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      #   description      = "${upper(regex_replace("Access", "", element(["SSH", "HTTPS", "Jenkins", "Sonarqube", "Prometheus", "HTTP"], port / 100)))} Access"
    }
  ]

  egress_rules = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "var.sg-name"
  }
}
