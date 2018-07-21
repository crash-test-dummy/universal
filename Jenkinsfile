pipeline {
  agent {
    label 'physical && virtualbox && vagrant'
  }

  triggers {
    issueCommentTrigger('.*ok to test.*')
    cron('@daily')
  }

  options {
    disableConcurrentBuilds()
    timeout(time: 30, unit: 'MINUTES')
    notificationContext('blah')
  }

  environment {
    VM_CPUS = '4'
    VM_RAM = '4096'
  }

  stages {

    stage('Build') {
      steps {
        sh 'DISPLAY=:0 vagrant up'
      }
    }

    stage('Lint') {
      steps {
        sh 'vagrant ssh -c \'$(npm bin)/grunt lint\''
      }
    }

    stage('Tests') {
      parallel {
        stage('Browsers') {
          steps {
            sh 'vagrant ssh -c \'$(npm bin)/testem ci --parallel 2 --file tests/testem.js\''
          }
        }
        stage('Node') {
          steps {
            sh 'vagrant ssh -c \'$(npm bin)/nyc node tests/all-tests.js\''
          }
        }
      }
    }
  }

  post {
    cleanup {
      sh 'vagrant halt -f && vagrant destroy -f' // https://github.com/hashicorp/vagrant/issues/8104
    }
    always {
      script {
        if (env.CHANGE_ID) {
          pullRequest.comment("Build [${env.BUILD_NUMBER}](${env.BUILD_URL}) completed with status ${currentBuild.result} in ${currentBuild.durationString")
        }
      }
    }
  }

}
