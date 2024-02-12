def recipientEmailBuild = 'suryaanand456@gmail.com'
def recipientEmailDeploy = 'suryaanand@infotracktelematics.com'
def deploymentApprovalURL = "${env.BUILD_URL}input"
def feedbackPlaceholder = 'Enter your feedback here'

def emailBodyBuild = """
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; font-size: 16px;">
    <div style="max-width: 600px; margin: 0 auto;">
        <div style="background-color: #007bff; color: #fff; padding: 20px; text-align: center;">
            <h2>Build Approval Required</h2>
        </div>
        <div style="padding: 20px;">
            <p>Dear Team,</p>
            <p>Build of project <strong>${JOB_NAME}</strong> (build number ${BUILD_NUMBER}) requires your approval.</p>
            <p>Please click the following button to approve or reject:</p>
            <p>
                <a style="display: inline-block; background-color: #007bff; color: #fff; padding: 10px 20px; text-decoration: none; border-radius: 5px;" href="${deploymentApprovalURL}">Approve / Reject</a>
            </p>
            <p>Your feedback is important to us. Please provide your comments or suggestions below:</p><br>
            <p>Regards,<br>Your Name</p>
        </div>
    </div>
</body>
</html>
"""

def emailBodyDeploy = """
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: Arial, sans-serif; font-size: 16px;">
    <div style="max-width: 600px; margin: 0 auto;">
        <div style="background-color: #007bff; color: #fff; padding: 20px; text-align: center;">
            <h2>Deployment Approval Required</h2>
        </div>
        <div style="padding: 20px;">
            <p>Dear Team,</p>
            <p>Deployment of project <strong>${JOB_NAME}</strong> (build number ${BUILD_NUMBER}) requires your approval.</p>
            <p>Please click the following button to approve or reject:</p>
            <p>
                <a style="display: inline-block; background-color: #007bff; color: #fff; padding: 10px 20px; text-decoration: none; border-radius: 5px;" href="${deploymentApprovalURL}">Approve / Reject</a>
            </p>
            <p>Your feedback is important to us. Please provide your comments or suggestions below:</p><br>
            <p>Regards,<br>Your Name</p>
        </div>
    </div>
</body>
</html>
"""


pipeline {
    agent any

    stages {
        stage('Checkout') {
            agent {
                label 'mdvr' // Specify the label of the Linux node here
            }
            steps {
                git branch: 'prod', url: 'https://github.com/8919134556/sample-proj-multi-branch.git'
            }
        }
        
        stage('Build Approval') {
            steps {
                script {
                    // Approval for Build stage
                    emailext body: emailBodyBuild,
                             subject: 'Build Approval Required',
                             to: recipientEmailBuild,
                             mimeType: 'text/html'
                    def approval = input message: 'Waiting for build approval',
                                           ok: 'Proceed',
                                           submitter: 'build-approver',
                                           parameters: [
                                               string(defaultValue: '', description: 'Enter your feedback', name: 'feedback'),
                                               booleanParam(defaultValue: false, description: 'Approve', name: 'approve')
                                           ]
                    if (!approval['approve']) {
                        error "Build stage approval denied."
                    }
                }
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Do you want to proceed with the build?', ok: 'Proceed'
                }
            }
        }
        
        stage('Build and Push Docker Image') {
            agent {
                label 'mdvr' // Specify the label of the Linux node here
            }
            steps {
                // Build Docker image
                sh 'docker build -t 9989228601/sample-project-prod:1 .'
                
                // Push Docker image to Docker Hub registry
                withCredentials([usernamePassword(credentialsId: '377e98fd-7ba5-4b8f-a3a2-405f82ade900', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push 9989228601/sample-project-prod:1'
                }
            }
        }
        
        stage('Deployment Approval') {
            steps {
                script {
                    // Approval for Deploy prod
                    emailext body: emailBodyDeploy,
                             subject: 'Deployment Approval Required',
                             to: recipientEmailDeploy,
                             mimeType: 'text/html'
                    def approval = input message: 'Waiting for deployment approval',
                                           ok: 'Proceed',
                                           submitter: 'deploy-approver',
                                           parameters: [
                                               string(defaultValue: '', description: 'Enter your feedback', name: 'feedback'),
                                               booleanParam(defaultValue: false, description: 'Approve', name: 'approve')
                                           ]
                    if (!approval['approve']) {
                        error "Deployment Prod approval denied."
                    }
                }
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Do you want to proceed with the deployment?', ok: 'Proceed'
                }
            }
        }
        
        stage('Deploy to Kubernetes Production') {
            agent {
                label 'mdvr' // Specify the label of the Linux node here
            }
            steps {
                // Apply Kubernetes manifests to prodction environment
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}