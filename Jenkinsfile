pipeline {
  agent {
    node {
      label 'test1'
    }
    
  }
  stages {
    stage('mybuild') {
      parallel {
        stage('mybuild') {
          steps {
            echo 'build step'
          }
        }
        stage('stage1') {
          steps {
            echo 'step2'
          }
        }
        stage('stage2') {
          steps {
            task(name: 'r-task')
          }
        }
      }
    }
    stage('mytest') {
      steps {
        echo 'test step'
      }
    }
    stage('uatmy') {
      steps {
        echo 'my uat'
      }
    }
    stage('deploy') {
      steps {
        echo 'mydeploy'
      }
    }
  }
}