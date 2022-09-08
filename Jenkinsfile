pipeline {
	agent any
	environment {
		AWS_ACCESS_KEY = credentials('aws_access_key')
		AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
	}

	stages {
		stage('Build') {
			steps {
				echo "Building..."
				sh('echo ${AWS_ACCESS_KEY}')
				sh('echo ${AWS_SECRET_ACCESS_KEY}')
				sh 'terraform init'
				sh 'terraform -version'
			}
		}
	}
}
