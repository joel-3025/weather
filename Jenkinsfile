pipeline {
  agent any

  environment {
    ARM_CLIENT_ID       = 'f22922a1-9e51-4f80-9414-007aa4dc2c9e'
    ARM_CLIENT_SECRET   = 'E0v8Q~SzTqtq6PU-v-9cv-jVc4DR5Waes~4AbbRh'
    ARM_TENANT_ID       = '57e99d21-825c-451e-a374-8121d0c998ef'
    ARM_SUBSCRIPTION_ID = '78538b16-31cc-4bc6-ae0a-706671075959'
    TF_REGISTRY_CLIENT_TIMEOUT = '300'
    TF_PLUGIN_CACHE_DIR = 'C:\\terraform-plugins-cache'
  }

  stages {
    stage('Checkout Code') {
      steps {
        echo "📦 Cloning repository..."
        git branch: 'main', url: 'https://github.com/joel-3025/weather.git'
      }
    }

    stage('Initialize Terraform') {
      steps {
        echo "🚀 Initializing Terraform..."
        bat 'terraform --version'

        retry(3) {
          bat 'terraform init -input=false -no-color'
        }
      }
    }

    stage('Validate Configuration') {
      steps {
        echo "🧩 Validating Terraform configuration..."
        bat 'terraform validate'
      }
    }

    stage('Plan Deployment') {
      steps {
        echo "🧱 Creating Terraform plan..."
        bat 'terraform plan -out=tfplan -input=false -no-color'
      }
    }

    stage('Apply Deployment') {
      steps {
        echo "☁️ Applying Terraform plan to Azure..."
        bat 'terraform apply -auto-approve tfplan'
      }
    }
  }

  post {
    success {
      echo '✅ Website updated successfully on Azure!'
    }
    failure {
      echo '❌ Deployment failed. Check console output for details.'
    }
  }
}
