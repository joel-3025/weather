pipeline {
  agent any

  environment {
    // Use Jenkins credentials (add them under Manage Jenkins -> Credentials)
  ARM_CLIENT_ID       = 'f22922a1-9e51-4f80-9414-007aa4dc2c9e'
  ARM_CLIENT_SECRET   = 'E0v8Q~SzTqtq6PU-v-9cv-jVc4DR5Waes~4AbbRh'
  ARM_TENANT_ID       = '57e99d21-825c-451e-a374-8121d0c998ef'
  ARM_SUBSCRIPTION_ID = '78538b16-31cc-4bc6-ae0a-706671075959'
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
        echo "🚀 Initializing Terraform (using proxy settings)..."
        // Wrap terraform steps with proxy-related environment variables
        withEnv([
          // <<< REPLACE THESE proxy values with your real proxy host:port >>>
          'HTTP_PROXY=http://proxy.example.com:3128',
          'HTTPS_PROXY=http://proxy.example.com:3128',
          // Exclude localhost and Azure metadata endpoint if needed
          'NO_PROXY=localhost,127.0.0.1,169.254.169.254',
          // Increase registry client timeout for slow networks
          'TF_REGISTRY_CLIENT_TIMEOUT=120'
        ]) {
          // debug: show terraform version available to Jenkins agent
          bat 'terraform --version'

          // initialize providers (uses proxy env)
          bat 'terraform init -input=false -no-color'
        }
      }
    }

    stage('Validate Configuration') {
      steps {
        echo "🧩 Validating Terraform configuration..."
        withEnv(['HTTP_PROXY=http://proxy.example.com:3128','HTTPS_PROXY=http://proxy.example.com:3128','NO_PROXY=localhost,127.0.0.1,169.254.169.254','TF_REGISTRY_CLIENT_TIMEOUT=120']) {
          bat 'terraform validate'
        }
      }
    }

    stage('Plan Deployment') {
      steps {
        echo "🧱 Creating Terraform plan..."
        withEnv(['HTTP_PROXY=http://proxy.example.com:3128','HTTPS_PROXY=http://proxy.example.com:3128','NO_PROXY=localhost,127.0.0.1,169.254.169.254','TF_REGISTRY_CLIENT_TIMEOUT=120']) {
          bat 'terraform plan -out=tfplan -input=false -no-color'
        }
      }
    }

    stage('Apply Deployment') {
      steps {
        echo "☁️ Applying Terraform plan to Azure..."
        withEnv(['HTTP_PROXY=http://proxy.example.com:3128','HTTPS_PROXY=http://proxy.example.com:3128','NO_PROXY=localhost,127.0.0.1,169.254.169.254','TF_REGISTRY_CLIENT_TIMEOUT=120']) {
          // Terraform will use ARM_* env variables from the top environment block for auth
          bat 'terraform apply -auto-approve tfplan'
        }
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
