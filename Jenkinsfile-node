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
    stage('Deploy') {
        docker.image('cdrx/pyinstaller-linux:python2').inside {
            sh 'pyinstaller --onefile sources/add2vals.py'
            archiveArtifacts 'dist/add2vals'
        }
    }
}
