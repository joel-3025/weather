pipeline {
    agent any

    environment {
        // Prefer using Jenkins credentials (recommended). For quick local test you may hardcode
        ARM_CLIENT_ID       = 'f22922a1-9e51-4f80-9414-007aa4dc2c9e'
        ARM_CLIENT_SECRET   = 'E0v8Q~SzTqtq6PU-v-9cv-jVc4DR5Waes~4AbbRh'
        ARM_TENANT_ID       = '57e99d21-825c-451e-a374-8121d0c998ef'
        ARM_SUBSCRIPTION_ID = '78538b16-31cc-4bc6-ae0a-706671075959'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📦 Cloning repository...'
                git branch: 'main', url: 'https://github.com/joel-3025/weather.git'
            }
        }

        stage('Initialize Terraform') {
            steps {
                echo '🚀 Initializing Terraform...'
                // Windows: use bat
                bat 'terraform --version'
                bat 'terraform init -input=false'
            }
        }

        stage('Validate Configuration') {
            steps {
                echo '🧩 Validating Terraform configuration...'
                bat 'terraform validate'
            }
        }

        stage('Plan Deployment') {
            steps {
                echo '🧱 Generating Terraform plan...'
                bat 'terraform plan -out=tfplan -input=false'
            }
        }

        stage('Apply Deployment') {
            steps {
                echo '☁️ Applying Terraform changes to Azure...'
                // Note: -auto-approve used so no interactive prompt
                bat 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo '✅ Website updated successfully on Azure!'
        }
        failure {
            echo '❌ Deployment failed. Check logs for details!'
        }
    }
}
