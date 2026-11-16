pipeline {

    agent any

    environment {
        IMAGE_NAME = "devops-3d-site"
        CONTAINER_NAME = "devops-3d-site"
        APP_PORT = "8081"
        BUILD_TAG_NAME = "build-${BUILD_NUMBER}"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    stages {

        stage('01 - Checkout') {
            steps {
                echo 'Recuperation du code source'
                checkout scm

                sh 'ls -la'
            }
        }

        stage('02 - Verification') {
            steps {
                echo 'Verification des fichiers du projet'

                sh '''
                    test -f index.html
                    test -f Dockerfile

                    echo "Fichiers verifies avec succes"
                '''
            }
        }

        stage('03 - Build Docker') {
            steps {
                echo 'Construction de image Docker'

                sh '''
                    docker build \
                    -t ${IMAGE_NAME}:${BUILD_TAG_NAME} \
                    -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        stage('04 - Test Docker') {
            steps {
                echo 'Verification de la configuration Nginx'

                sh '''
                    docker run --rm \
                    ${IMAGE_NAME}:${BUILD_TAG_NAME} \
                    nginx -t
                '''
            }
        }

        stage('05 - Deploy') {
            steps {
                echo 'Deploiement du mini-site 3D'

                sh '''
                    docker rm -f ${CONTAINER_NAME} || true

                    docker run -d \
                    --name ${CONTAINER_NAME} \
                    --restart unless-stopped \
                    -p ${APP_PORT}:80 \
                    ${IMAGE_NAME}:${BUILD_TAG_NAME}
                '''
            }
        }

        stage('06 - Health Check') {
            steps {
                echo 'Verification du site web'

                sh '''
                    for i in $(seq 1 15); do

                        if curl -fsS http://localhost:${APP_PORT}/ \
                            > /dev/null; then

                            echo "Site accessible avec succes"
                            exit 0
                        fi

                        sleep 2
                    done

                    echo "Erreur: site inaccessible"
                    exit 1
                '''
            }
        }
    }

    post {

        success {
            echo '================================'
            echo 'CI/CD SUCCESS'
            echo 'Mini-site 3D deploye'
            echo 'URL: http://localhost:8081'
            echo '================================'
        }

        failure {
            echo '================================'
            echo 'CI/CD FAILED'
            echo 'Verifier les logs Jenkins'
            echo '================================'
        }

        always {
            sh 'docker ps -a || true'
            echo 'Pipeline terminee'
        }
    }
}
