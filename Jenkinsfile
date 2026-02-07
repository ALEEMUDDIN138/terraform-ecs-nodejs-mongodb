pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REPO = "253339176093.dkr.ecr.us-east-1.amazonaws.com/terraform-ecs-nodejs-mongodb"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t terraform-ecs-nodejs-mongodb:$IMAGE_TAG .'
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO

                docker tag terraform-ecs-nodejs-mongodb:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
                docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

        stage('Terraform Deploy') {
            steps {
                sh '''
                terraform init
                terraform apply -var="image_tag=$IMAGE_TAG" -auto-approve
                '''
            }
        }
    }
}
