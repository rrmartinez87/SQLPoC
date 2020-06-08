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
            sh 'sudo rm -r *;sudo git clone https://github.com/rrmartinez87/SQLPoC.git'
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
        stage('Terraform Apply') {
            when {
                expression { params.REQUESTED_ACTION == 'create'}
            }
		steps {
                sh '''
                terraform plan -no-color -out out.plan
                terraform apply -no-color out.plan
                '''
            }
        }
		stage('Terraform Destroy') {
            when {
                expression { params.REQUESTED_ACTION == 'destroy' }
            }
            steps {
            sh '''
            terraform destroy -no-color --auto-approve
            '''
            }
        }
        stage('Clean WorkSpace') {
            steps {
                echo "Wiping workspace $pwd"
                cleanWs()
            }
        }
    }
}