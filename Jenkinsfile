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
	    options {
                azureKeyVault(
                    credentialID: 'jenkins-sp-sql', 
                    keyVaultURL: 'https://Sqltfstatekv-test-03.vault.azure.net/', 
                    secrets: [
                        [envVariable: 'TF_VAR_client_id', name: 'spn-id', secretType: 'Secret'],
                        [envVariable: 'TF_VAR_client_secret', name: 'spn-secret', secretType: 'Secret'],
                        [envVariable: 'StorageAccountAccessKey', name: 'TerraformSASToken', secretType: 'Secret']
                    ]
                )
            }	
		steps {
                sh '''
		cd SQLPoC
		export TF_VAR_client_id=$TF_VAR_client_id
                export TF_VAR_client_secret=$TF_VAR_client_secret
		terraform init -no-color -backend-config="storage_account_name=sqltfstatestgtest" \
                -backend-config="container_name=sqltfstate" \
                -backend-config="access_key=$StorageAccountAccessKey" \
                -backend-config="key=terraform.sqltfstate"
		terraform plan -no-color -out out.plan -lock=false
                terraform apply -no-color out.plan -lock=false
                '''
            }
        }
		stage('Terraform Destroy') {
            when {
                expression { params.REQUESTED_ACTION == 'destroy' }
            }
	    options {
                azureKeyVault(
                    credentialID: 'jenkins-sp-sql', 
                    keyVaultURL: 'https://Sqltfstatekv-test-03.vault.azure.net/', 
                    secrets: [
                        [envVariable: 'TF_VAR_client_id', name: 'spn-id', secretType: 'Secret'],
                        [envVariable: 'TF_VAR_client_secret', name: 'spn-secret', secretType: 'Secret'],
                        [envVariable: 'StorageAccountAccessKey', name: 'TerraformSASToken', secretType: 'Secret']
                    ]
                )
            }		
            steps {
            sh '''
            cd SQLPoC
            export TF_VAR_client_id=$TF_VAR_client_id
            export TF_VAR_client_secret=$TF_VAR_client_secret
            terraform init -no-color -backend-config="storage_account_name=sqltfstatestgtest" \
            -backend-config="container_name=sqltfstate" \
            -backend-config="access_key=$StorageAccountAccessKey" \
            -backend-config="key=terraform.sqltfstate"
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
