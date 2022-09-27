pipeline {
    agent any
    parameters {
				choice(name: 'CREATOR', choices: ['Build', 'Destroy'], description: 'Pick something')
    }
		environment {
			CHOICE = "${params.CREATOR}"
		}
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.CREATOR}"
								echo "ENV VAR: $CHOICE"
            }
        }
				stage('Example 2 - conditional = Build') {
					when {
						environment name: 'CHOICE', value: 'Build'
					}
            steps {
                echo "Hello ${params.CREATOR}"
								echo "ENV VAR: $CHOICE"
            }
				}
    }
}
