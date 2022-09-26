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
				// sh('terraform apply -auto-approve')
				sh('terraform apply -destroy -auto-approve')
			}
		}

		stage('Provision') {
			environment {
				PUBLIC_IP_NODE_1 =
				"""
					${sh(
					returnStdout: true,
					script: 'terraform output -raw EC2_node_1_public_ip'
				)}"""
				PUBLIC_IP_NODE_2 =
				"""
					${sh(
					returnStdout: true,
					script: 'terraform output -raw EC2_node_2_public_ip'
				)}"""
				PUBLIC_IP_NODE_3 =
				"""
					${sh(
					returnStdout: true,
					script: 'terraform output -raw EC2_node_3_public_ip'
				)}"""
			}
			steps {
				echo "Provisioning..."
				ansiblePlaybook (
					playbook: 'provision_rhel_aws.yml',
					extras: '-e NODE_1_IP_ADDR=${PUBLIC_IP_NODE_1} -e NODE_2_IP_ADDR=${PUBLIC_IP_NODE_2} -e NODE_3_IP_ADDR=${PUBLIC_IP_NODE_3}',
					colorized: true
				)
			}
		}
	}
}
