node {
    withDockerContainer(image: 'python:2-alpine') {
        stage('Build') {
            echo 'Build Started'
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            echo 'Build Finished'
        }
    }
    withDockerContainer(image: 'qnib/pytest') {
        try {
            stage('Test') {
                echo 'Test Started'
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
        } catch (e) {
            echo 'Test Failed'
        } finally {
            junit 'test-reports/results.xml'
            echo 'Test Finished'
        }
    }
    withDockerContainer(image: 'cdrx/pyinstaller-linux:python2') {
        try {
            stage('Deploy') {
                echo 'Deploy Started'
                sh 'pyinstaller --onefile sources/add2vals.py'
            }
        } catch (e) {
            echo 'Deploy Failed'
        } finally {
            archiveArtifacts 'dist/add2vals'
            echo 'Deploy Succeded'
            sh 'sleep 1m'
            echo 'Application Shutting down...'
        }
    }
}
