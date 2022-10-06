node {
    withDockerContainer(image: 'python:2-alpine') {
        stage('Build') {
            echo 'Build Started'
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
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
    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy? (Klik "Proceed" untuk lanjut)'
    }
    withEnv(["VOLUME=${'$(pwd)/sources:/src'}", "IMAGE='cdrx/pyinstaller-linux:python2'"]) {
        try {
            stage('Deploy') {
                dir(path: env.BUILD_ID) {
                    unstash(name: 'compiled-results')
                    sh "docker run --rm -v ${VOLUME} ${IMAGE} 'pyinstaller -F add2vals.py'"
                }
            }
        } catch (e) {
            echo 'Deploy Failed'
        } finally {
            echo 'Tes penjumlahan 10 dan 12'
            sh "${env.BUILD_ID}/sources/dist/add2vals 10 12"
            echo 'Tes penjumlahan 4 dan 5'
            sh "${env.BUILD_ID}/sources/dist/add2vals 4 5"
            sh 'sleep 1m'
            archiveArtifacts "${env.BUILD_ID}/sources/dist/add2vals"
            sh "docker run --rm -v ${VOLUME} ${IMAGE} 'rm -rf build dist'"
        }
    }
    stage('Push to Github') {
        sh 'deploy.sh'
    }
}
