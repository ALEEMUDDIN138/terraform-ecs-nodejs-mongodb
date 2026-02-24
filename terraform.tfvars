################################
# GLOBAL
################################
region       = "us-east-1"
project_name = "terraform-ecs-nodejs-mongodb"
environment  = "production"

################################
# DOCKER IMAGE
################################
image_tag = "latest"

################################
# MONGODB URI (Atlas Example)
################################
mongo_uri = "mongodb+srv://mongodbuser:mongodb123@terraform-ecd--nodejs-m.d4odikf.mongodb.net/?appName=Terraform-ecd--nodejs-mangodb"

################################
# ECS SETTINGS
################################
task_cpu      = "256"
task_memory   = "512"
desired_count = 2


