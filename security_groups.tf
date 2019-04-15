resource "aws_security_group" "terraform_elb_security_group" {
  description = "Grupo de seguranca do loadbalancer."

  vpc_id = "${aws_vpc.terraform_vpc.id}"
  name   = "terraform_elb_security_group"

  /*
  #Configurar entrada quando disponivel SSL na aplicação.
    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    */

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "terraform_ecs_security_group" {
  description = "Baseados lo loadbalancer e liberando demais portas da instancia EC2 por baixo."
  vpc_id      = "${aws_vpc.terraform_vpc.id}"
  name        = "terraform_ecs_security_group"

  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    description = "Acessados pelo loadbalancer configurado."

    security_groups = [
      "${aws_security_group.terraform_elb_security_group.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
