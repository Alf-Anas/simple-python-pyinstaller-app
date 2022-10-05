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
    withEnv(["VOLUME=${'$(pwd)/sources:/src'}", "IMAGE='cdrx/pyinstaller-linux:python2'"]) {
        try {
            stage('Deploy') {
                sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
            }
        } catch (e) {
            echo 'Deploy Failed'
        } finally {
            archiveArtifacts 'sources/dist/add2vals'
            sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
        }
    }
}
