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
        stage('Firefox') {
          steps {
            sh 'vagrant ssh -c \'$(npm bin)/testem --port $((RANDOM+1024)) --launch Firefox ci --file tests/testem.js\''
          }
        }
        stage('Chrome') {
          steps {
            sh 'vagrant ssh -c \'$(npm bin)/testem --port $((RANDOM+1025)) --launch Chrome ci --file tests/testem.js\''
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
          pullRequest.comment("Build status: " + currentBuild.result)
        }
      }
    }
  }

}
