/**
 * Definindo variavel utilizada na criação de containers ecs
 */
variable "instance_type" {
  default     = "t2.medium"
  description = "Instancia Media tipo T2 AWS."
}

variable "max_ecs_ec2_instances" {
  default     = 2
  description = "O numero maximo de instancias EC2 que podem ser escaladas pela aplicacao."
}

variable "min_ecs_ec2_instances" {
  default     = 1
  description = "O numero minimo de instancias EC2 em cluster ECS para rodar a aplicacao."
}

variable "desired_capacity_ecs_ec2_instances" {
  default     = 1
  description = "O numero desejado de instancias EC2 em cluster ECS para rodar a aplicacao."
}

variable "application_container_name" {
  /** Carregado pela variavel de ambiente .env da aplicação */
  default     = "terraform_application_container"
  description = "O numero desejado de instancias EC2 em cluster ECS para rodar a aplicacao."
}
