pipeline {
  agent any

  environment {
    TERRAFORM_VERSION = '0.12.26'
    TERRAFORM_DIR = '/path/to/your/terraform/files'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('Plan') {
      steps {
        sh 'terraform plan'
      }
    }
    stage('Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
  }

  post {
    failure {
      mail to: 'your-email@example.com',
           subject: 'Jenkins Pipeline Failed',
           body: "Pipeline failed at ${env.BUILD_URL}"
    }
  }
}
