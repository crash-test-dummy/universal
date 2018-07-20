pipeline {
  agent {
    label 'physical && virtualbox && vagrant'
  }

  triggers {
    issueCommentTrigger('.*ok to test.*')
  }

  environment {
    VM_CPUS = '4'
    VM_MEMORY = '4096'
  }

  stages {

    stage('Build') {
      steps {
        sh 'DISPLAY=:0 vagrant up'
      }
    }

    stage('Lint') {
      steps {
        sh 'vagrant ssh -c "$(npm bin)/grunt lint"'
      }
    }

    stage('Tests') {
      parallel {
        stage('Firefox') {
          steps {
            sh 'vagrant ssh -c "$(npm bin)/testem -l Firefox ci --file tests/testem.js"'
          }
        }
        stage('Chrome') {
          steps {
            sh 'vagrant ssh -c "$(npm bin)/testem -l Chrome ci --file tests/testem.js"'
          }
        }
        stage('Node') {
          steps {
            sh 'vagrant ssh -c "$(npm bin)/nyc node tests/all-tests.js"'
          }
        }
      }
    }
  }

  post {
    always {
      sh 'vagrant halt -f && vagrant destroy -f' // https://github.com/hashicorp/vagrant/issues/8104
    }
 
    failure {
      script {
        if (env.CHANGE_ID) {
          pullRequest.comment("@" + pullRequest.createdBy + ": continuous integration build failed")
        }
      }
    }
  }

}
