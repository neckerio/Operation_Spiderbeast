pipeline {
	agent any
	stages {
		stage('Hello') {
			steps {
				sh 'echo HELLO'
				echo "Build Number is ${currentBuild.number}"	
			}
			post {
				success {
					script {
						current.Build.result = 'SUCCESS'
					}
				}
			}
		}
	}
	post {
		always {
			echo currentBuild.currentResult
		}
	}
}
