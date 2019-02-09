#!groovy
 
pipeline {
  agent {
    label 'host'
  }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '7'))
    disableConcurrentBuilds()
  }
  
  parameters {
    string(name: 'Count', defaultValue: '0', description: 'Number of instanzes to start')
    credentials(name: 'AWS_Key', description: 'AWS_Key', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )
    credentials(name: 'AWS_Secret', description: 'AWS_Secret', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )
    string(name: 'Private_Key_Name', defaultValue: '', description: 'Private Key Name')
    credentials(name: 'Private_Key', description: 'AWS Private Key', defaultValue: '', credentialType: "com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey", required: true )
  }

  stages {
 
    stage("Set Build Parameters") {
      steps {
        script {
          currentBuild.displayName = "Create_Environment .${BUILD_NUMBER}";
        }
      }
    }

    stage("Terraform init") {
      steps {
        sh "docker run --rm -w /work -v ${WORKSPACE}/terraform/:/work hashicorp/terraform init"
      }
    }

    stage("Terraform plan") {
      steps {
        dir("${WORKSPACE}"){
          withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY'), sshUserPrivateKey(credentialsId: "${params.Private_Key}", keyFileVariable: 'PRIVATE_KEY', passphraseVariable: '', usernameVariable: 'USERNAME')]) {
            sh "docker run --rm -w /work -v ${PRIVATE_KEY}:/certs/cert.pem -v ${WORKSPACE}/terraform/:/work hashicorp/terraform plan -out=tfplan -input=false -var \"access_key=${AWS_KEY}\" -var \"secret_key=${AWS_SECRET}\" -var \"private_key_name=${params.Private_Key_Name}\" -var \"count=${params.Count}\" -var \"private_key=/certs/cert.pem\"  "
          }
        }
      }
    }

    stage("Terraform Apply") {
      steps {
        withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY'), sshUserPrivateKey(credentialsId: "${params.Private_Key}", keyFileVariable: 'PRIVATE_KEY', passphraseVariable: '', usernameVariable: 'USERNAME')]) {
          sh "docker run --rm -w /work -v ${PRIVATE_KEY}:/certs/cert.pem -v ${WORKSPACE}/terraform/:/work hashicorp/terraform apply  --auto-approve -input=false tfplan"
        }
      }
    }

  }
 
}
