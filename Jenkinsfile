pipeline {
    agent any
		input {
                message "Should we continue?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }

    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"
            }
        }
				stage('Example 2') {
            steps {
                echo "Hello ${params.PERSON}"
            }
				}
    }
}
