#Criando repositorio ECR da aplicação.
resource "aws_ecr_repository" "terraform_repository" {
  name = "terraform_repository"
}

#Criando Clouster da aplicação
resource "aws_ecs_cluster" "terraform_cluster" {
  name = "terraform_cluster"
}

/**
 * Carregando configurações bases das instancias
 * EC2 que serão iniciadas dentro da infraesreutura
 * você pode conferir os arquivos de variaveis usados
 * dentro desse resource em data.tf e vars.tf
 */
resource "aws_launch_configuration" "terraform_cluster_lc" {
  name_prefix = "terraform_cluster_lc"

  /** Carregando grupo de seguranca baseado no application load balancer porém com definições proprias. */
  security_groups = ["${aws_security_group.terraform_ecs_security_group.id}"]

  /** key_name                    = "${aws_key_pair.demodev.key_name} */
  image_id             = "${data.aws_ami.latest_ecs.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_ec2_instance_profile.id}"

  /** Atenção dentro do template é utilizado o nome do cluster ecs criado (para configurar instancias EC2) */
  user_data                   = "${data.template_file.ecs-cluster.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

/** Criando grupo de escalabilidade, selecinando as sunets publicas e habilitadas no aplication loadbalancer também. */
resource "aws_autoscaling_group" "terraform_cluster_autoscaling_group" {
  name                      = "terraform_cluster_autoscaling_group"
  vpc_zone_identifier       = ["${aws_subnet.terraform_subnet_public_1.id}", "${aws_subnet.terraform_subnet_public_2.id}", "${aws_subnet.terraform_subnet_public_3.id}"]
  min_size                  = "${var.min_ecs_ec2_instances}"
  max_size                  = "${var.max_ecs_ec2_instances}"
  desired_capacity          = "${var.desired_capacity_ecs_ec2_instances}"
  launch_configuration      = "${aws_launch_configuration.terraform_cluster_lc.name}"
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "terraform_cluster_lc"
    propagate_at_launch = true
  }
}

/** Criando politica para auto escalar o cluster */
resource "aws_autoscaling_policy" "terraform_cluster_autoscaling_policy" {
  name                      = "terraform_cluster_autoscaling_policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = "${aws_autoscaling_group.terraform_cluster_autoscaling_group.name}"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    /** Replica instancias quando a CPU bate 40% de utilização */
    target_value = 40.0
  }
}
