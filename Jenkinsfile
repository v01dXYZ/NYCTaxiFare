pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dir('viz') {
                     sh 'Rscript exec.R'
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
