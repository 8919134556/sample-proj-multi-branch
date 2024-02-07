pipeline {
    agent {
        label 'mdvr' // Specify the label of the Linux node here
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    environment {
                        DOCKER_USERNAME = credentials('DOCKER_HUB_USERNAME')
                        DOCKER_PASSWORD = credentials('DOCKER_HUB_PASSWORD')
                    }
                    // Build Docker image for production
                    sh 'docker build -t 9989228601/sample-project:staging .'
                    
                    // Push Docker image to Docker Hub registry
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push 9989228601/sample-project:staging'
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                // Apply Kubernetes manifests to production environment
                sh 'kubectl apply -f prod-deployment.yaml'
            }
        }
    }
}
