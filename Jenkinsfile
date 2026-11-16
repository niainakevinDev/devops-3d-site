pipeline {

    agent any

    environment {
        IMAGE_NAME = "devops-3d-site"
        CONTAINER_NAME = "devops-3d-site"
        APP_PORT = "8081"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Recuperation du code source'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construction de l image Docker'
                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Test Docker Image') {
            steps {
                echo 'Verification de Nginx'
                sh '''
                    docker run --rm \
                    ${IMAGE_NAME}:${BUILD_NUMBER} nginx -t
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploiement du site'

                sh '''
                    docker rm -f ${CONTAINER_NAME} || true

                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    --restart unless-stopped \
                    -p ${APP_PORT}:80 \
                    ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }

        stage('Verification') {
            steps {
                echo 'Verification du conteneur'

                sh '''
                    docker ps --filter name=${CONTAINER_NAME}
                    docker inspect ${CONTAINER_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD SUCCESS - SITE DEPLOYE'
        }

        failure {
            echo 'CI/CD FAILED - VERIFIER LES LOGS'
        }

        always {
            echo 'Pipeline terminee'
        }
    }
}
