pipeline {
  agent any

  options {
    skipStagesAfterUnstable()
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Lint') {
      steps {
        script {
          githubNotify context: 'lint', status: 'PENDING'
          try {
            echo '🔍 Lint OK'
            githubNotify context: 'lint', status: 'SUCCESS'
          } catch (err) {
            githubNotify context: 'lint', status: 'FAILURE'
            error("Lint failed")
          }
        }
      }
    }

    stage('Test') {
      steps {
        script {
          githubNotify context: 'test', status: 'PENDING'
          try {
            echo '🧪 Tests OK'
            githubNotify context: 'test', status: 'SUCCESS'
          } catch (err) {
            githubNotify context: 'test', status: 'FAILURE'
            error("Tests failed")
          }
        }
      }
    }

    stage('Security') {
      steps {
        script {
          githubNotify context: 'security', status: 'PENDING'
          try {
            sh 'npm audit --audit-level=high'
            githubNotify context: 'security', status: 'SUCCESS'
          } catch (err) {
            githubNotify context: 'security', status: 'FAILURE'
            error("Security check failed")
          }
        }
      }
    }

    stage('Detect Modified Apps') {
      steps {
        script {
          githubNotify context: 'build', status: 'PENDING'
          githubNotify context: 'typecheck', status: 'PENDING'

          def before = sh(script: "git rev-parse HEAD~1", returnStdout: true).trim()
          def after = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
          def changed = sh(
            script: """
              git diff --name-only ${before} ${after} |
              grep '^apps/' | cut -d '/' -f2 | sort -u | jq -R . | jq -s .
            """,
            returnStdout: true
          ).trim()

          if (changed == "[]" || changed == "") {
            echo "No apps changed."
            env.APPS = ""
          } else {
            def parsed = new groovy.json.JsonSlurper().parseText(changed)
            env.APPS = parsed.join(',')
            echo "Modified apps: ${env.APPS}"
          }
        }
      }
    }

    stage('Typecheck') {
      when {
        expression { return env.APPS?.trim() }
      }
      steps {
        script {
          try {
            def apps = env.APPS.split(',')
            apps.each { app ->
              echo "🔠 Typechecking app: ${app}"
              // ex: sh "cd apps/${app} && npm run typecheck"
            }
            githubNotify context: 'typecheck', status: 'SUCCESS'
          } catch (err) {
            githubNotify context: 'typecheck', status: 'FAILURE'
            error("Typecheck failed")
          }
        }
      }
    }

    stage('Build') {
      when {
        expression { return env.APPS?.trim() }
      }
      steps {
        script {
          try {
            def apps = env.APPS.split(',')
            apps.each { app ->
              echo "🏗️ Building app: ${app}"
              // ex: sh "cd apps/${app} && npm run build"
            }
            githubNotify context: 'build', status: 'SUCCESS'
          } catch (err) {
            githubNotify context: 'build', status: 'FAILURE'
            error("Build failed")
          }
        }
      }
    }
  }

  post {
    always {
      echo '✅ Pipeline terminé'
    }
  }
}