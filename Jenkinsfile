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
						current.Build.result = 'UNSTABLE'
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
