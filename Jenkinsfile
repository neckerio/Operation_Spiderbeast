pipeline {
    agent any
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
    }
		environment {
			CHOICE = "${params.PERSON}"
		}
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"
								echo "ENV VAR: $CHOICE"
            }
        }
				stage('Example 2 - conditional = Build') {
					when {
						environment 
						name: 'CHOICE',
						value: 'Build'
					}
            steps {
                echo "Hello ${params.PERSON}"
								echo "ENV VAR: $CHOICE"
            }
				}
    }
}
