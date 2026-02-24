# ───────────────────────────────────────────────
# Existing variables (already in your file)
# ───────────────────────────────────────────────
variable "project_name" {}
variable "vpc_cidr" {}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

# ───────────────────────────────────────────────
# New variables for VPC Endpoints
# ───────────────────────────────────────────────

# The VPC ID where endpoints will be created
variable "vpc_id" {
  description = "VPC ID for creating VPC Endpoints"
  type        = string
}

# The list of private subnet IDs (endpoints will attach here)
variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECR interface endpoints"
  type        = list(string)
}

# The route table IDs used by private subnets (for the S3 Gateway Endpoint)
variable "private_route_table_ids" {
  description = "Route table IDs for private subnets"
  type        = list(string)
}

# The ECS tasks' security group ID (used to allow HTTPS to endpoints)
variable "ecs_tasks_sg_id" {
  description = "Security group ID of ECS tasks that need ECR access"
  type        = string
}

variable "create_vpc_endpoints" {
  type    = bool
  default = false
}
