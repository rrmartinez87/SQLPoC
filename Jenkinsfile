pipeline {
    parameters {
        choice(
            choices: ['create', 'destroy'],
            description: 'Select action to perform',
            name: 'REQUESTED_ACTION'
        )
    }
    agent any

    stages {
    stage('Clone repository') {
        steps {
            git branch: 'master', credentialsId: '880917La@', url: https://github.com/rrmartinez87/SQLPoC.git'
            }
        }
	stage('Set Terraform path') {
        steps {
             script {
                 def tfHome = tool name: 'Terraform'
                  env.PATH = "${tfHome}:${env.PATH}"
             }
                sh 'terraform -version'
            }
        }
        stage('tfsvars create') {
            steps {
                sh 'sudo cp /home/ec2-user/variables.tf ./jenkins'
            }
        }
        stage('terraform init') {
            steps {
                sh 'sudo /home/ec2-user/terraform init ./jenkins'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'ls ./jenkins; sudo /home/ec2-user/terraform plan ./jenkins'
            }
        }
        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}
