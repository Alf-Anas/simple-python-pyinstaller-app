pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'python:2-alpine'
                }
            }
            steps {
                sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'qnib/pytest'
                }
            }
            steps {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }
        stage('Deliver-Win') {
            agent {
                docker {
                    image 'cdrx/pyinstaller-windows:python3'
                }
            }
            steps {
                sh "echo 'Steps Started'"
                // sh 'pyinstaller --onefile sources/add2vals.py'
                sh "echo 'Steps Finished'"
            }
            post {
                success {
                    sh "echo 'Success'"
                    // archiveArtifacts 'dist/add2vals'
                    sh "echo 'Deliver Finished'"
                }
            }
        }
    }
}
