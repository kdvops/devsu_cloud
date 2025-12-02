pipeline {
    agent any

    environment {
        IMAGE_NAME = "silencfox/simpleApi"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds',
                    url: 'https://github.com/kdvops/simpleApi.git',
                    branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./App
                    """
                }
            }
        }
      
    }

    post {
        success {
            echo "Build completado correctamente"
        }
        failure {
            echo "El build falló"
        }
    }
}
