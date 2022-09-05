pipeline {
	agent any
	stages {
		Stage('Hello') {
			steps {
				sh 'echo HELLO'
				echo "Build Number is ${currentBuild.number}"	
			}
		}
	}
}
