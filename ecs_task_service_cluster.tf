/** Criando a taskDefinition do seriço a ser rodado no cluster */
resource "aws_ecs_task_definition" "terrafrom_ecs_task_definition" {
  family                = "service"
  container_definitions = "${file("templates/task_definition.json")}"
}

/**
 * Criando o serviço que será executado no cluster
 */
resource "aws_ecs_service" "terraform_ecs_service" {
  name            = "terraform_ecs_service"
  cluster         = "${aws_ecs_cluster.terraform_cluster.id}"
  task_definition = "${aws_ecs_task_definition.terrafrom_ecs_task_definition.arn}"
  desired_count   = 4
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"
  depends_on      = ["aws_iam_role_policy_attachment.ecs_service_attach"]

  load_balancer {
    target_group_arn = "${aws_alb_target_group.terraform_alb_target_group.id}"
    container_name   = "${var.application_container_name}"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}
