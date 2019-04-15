#Criando Load Balancer da Aplicação
resource "aws_alb" "terraform_alb" {
  /** Não aceita _ no nome */
  name                       = "terraform-alb"
  subnets                    = ["${aws_subnet.terraform_subnet_public_1.id}", "${aws_subnet.terraform_subnet_public_2.id}", "${aws_subnet.terraform_subnet_public_3.id}"]
  security_groups            = ["${aws_security_group.terraform_elb_security_group.id}"]
  enable_http2               = true
  idle_timeout               = 600
  enable_deletion_protection = false
}

#Dns de saida do loadbalancer publico usado para acessas a aplicação
output "terraform_lb_output" {
  value = "${aws_alb.terraform_alb.dns_name}"
}

resource "aws_alb_listener" "terraform_alb_front" {
  load_balancer_arn = "${aws_alb.terraform_alb.id}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.terraform_alb_target_group.id}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "terraform_alb_target_group" {
  /** Não aceita _ no nome */
  name       = "terraform-alb-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  depends_on = ["aws_alb.terraform_alb"]

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}
