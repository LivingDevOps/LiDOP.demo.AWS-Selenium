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
    string(name: 'VPN_IP', defaultValue: '0.0.0.0', description: 'OpenVPN Server')
  }

  stages {
 
    stage("Set Build Parameters") {
      steps {
        script {
          currentBuild.displayName = "Connect_Vpn .${BUILD_NUMBER}";
        }
      }
    }

    stage("Install OpenVPN") {
      steps {
        sh 'sudo apt-get install -y openvpn'
      }
    }

    stage("Configure OpenVON") {
      steps {
        sh "curl --insecure https://lidop:LiDOP2019@${params.VPN_IP}/rest/GetAutologin > /tmp/lidop.conf"
        sh "sudo cp /tmp/lidop.conf /etc/openvpn/lidop.conf"
        sh 'sudo systemctl restart openvpn@lidop'
      }
    }

  }
 
}
