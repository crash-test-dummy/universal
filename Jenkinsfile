pipeline {
  agent {
    label 'physical && virtualbox && vagrant'
  }

  triggers {
    issueCommentTrigger('.*ok to test.*')
  }

  stages {
				stage('build') {
				  steps {
				    sh 'DISPLAY=:0 vagrant up'
				  }
				}

				stage('lint') {
				  steps {
				    sh 'vagrant ssh -c "cd /home/vagrant/sync/universal; $(npm bin)/grunt lint"'
				  }
				}

				stage('browser tests') {
				  steps {
				    sh 'npm run test:vagrantBrowser'
				  }
				}

				stage('node tests') {
				  steps {
				    sh 'npm run test:vagrantNode'
				  }
				}
  }

  post {
    always {
      sh 'vagrant destroy -f'
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
