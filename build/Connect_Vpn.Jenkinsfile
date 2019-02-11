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
            sh "docker run --rm -w /work -v ${PRIVATE_KEY}:/certs/cert.pem -v ${WORKSPACE}/terraform/:/work hashicorp/terraform plan -out=tfplan -input=false -var \"access_key=${AWS_KEY}\" -var \"secret_key=${AWS_SECRET}\" -var \"private_key_name=${params.Private_Key_Name}\" -var \"private_key=/certs/cert.pem\"  "
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

    stage("Install Software") {
      steps {
        sh "curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -"
        sh "sudo apt-get install -y nodejs"
        sh 'sudo apt-get install -y openvpn'
      }
    }

    stage("Configure OpenVPN") {
      steps {
        sh "curl --insecure https://lidop:LiDOP2019@\$(sudo docker run --rm -w /work -v ${WORKSPACE}/terraform/:/work hashicorp/terraform output vpn_ip)/rest/GetAutologin > /tmp/lidop.conf"
        sh "sudo cp /tmp/lidop.conf /etc/openvpn/lidop.conf"
        sh 'sudo systemctl restart openvpn@lidop'
      }
    }

    stage("Wait vor VPN connect") {
      steps {
        timeout(5) {
          waitUntil {
            script {
              def r = sh script: 'wget --no-check-certificate -q https://172.10.10.10:443 -O /dev/null', returnStatus: true
              return (r == 0);
              }
            }
        }
      }
    }

  }
 
}
