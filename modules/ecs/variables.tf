variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "task_cpu" {
  type = string
}

variable "task_memory" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "mongo_secret_arn" {
  type = string
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
}
