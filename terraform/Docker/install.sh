  echo "########################################################"
  echo "### Install Docker #####################################"
  echo "########################################################"
  # Add Docker’s official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  
  # add the docker stable repository
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  
  apt-get update -y		
  apt-get install -y docker-ce
