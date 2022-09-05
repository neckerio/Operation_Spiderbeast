pipeline {
	agent any
	stages {
		stage('Hello') {
			steps {
				sh 'echo HELLO'
				echo "Build Number is ${currentBuild.number}"	
			}
		}
	}
}
