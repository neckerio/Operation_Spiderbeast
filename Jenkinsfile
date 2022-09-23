pipeline {
	agent any
	options {
		ansiColor('xterm')
	}
	tools {
		terraform 'terraform'
	}
	environment {
		AWS_ACCESS_KEY = credentials('aws_access_key')
		AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
		TF_VAR_EC2_PUBKEY = credentials('ec2-public')
	}

	stages {
		stage('Build') {
			steps {
				echo "Building..."
				sh('echo ${AWS_ACCESS_KEY}')
				sh('echo ${AWS_SECRET_ACCESS_KEY}')
				sh('terraform -version')
				sh('terraform init')
				sh('terraform plan')
				sh('terraform apply -auto-approve')
				// sh('terraform apply -destroy -auto-approve')
			}
		}

		stage('Provision') {
			steps {
				echo "Provisioning..."
				sh('PUBLIC_IP=$(terraform output -raw aws_instance_public_ip)')
				sh('echo $PUBLIC_IP')

			}
		}

		stage('Test') {
			steps {
				echo "Testing..."

				ansiblePlaybook (
					playbook: 'provision_rhel_aws.yml',
					extras: '-e IP_ADDR=$(PUBLIC_IP)',
					colorized: true
				)
			}
		}
	}
}
