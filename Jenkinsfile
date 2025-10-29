pipeline {
  agent any

  environment {
    // Use Jenkins credentials (add them under Manage Jenkins -> Credentials)
    ARM_CLIENT_ID       = credentials('ARM_CLIENT_ID')
    ARM_CLIENT_SECRET   = credentials('ARM_CLIENT_SECRET')
    ARM_TENANT_ID       = credentials('ARM_TENANT_ID')
    ARM_SUBSCRIPTION_ID = credentials('ARM_SUBSCRIPTION_ID')
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
