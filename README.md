Project:- Completed Devops CI-CD
--------------------------------


-> create 2 ec2 instance one is for master-Node and another one is for Worker-Node (creating K8s cluster)
----------------------------------------------------------------------------------------------------------

-> Then Follow the below step
-----------------------------
# Step1:

Master and slave 
vim install.sh (create vim file) and put the below command into the file

apt-get update -y

apt-get install docker.io -y

service docker restart  

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -  

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list

apt-get update

apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y  

sh install.sh (run the vim file)

# Step2:

Master node:

   kubeadm init --pod-network-cidr=192.168.0.0/16
   
   *If above one fails then run below command
   
   kubeadm token create --print-join-command (run this command on to the worker-node)
  
# Step3: 

Master node: 

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
# step4:

Master node:

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml 

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml
 
kubectl get nodes


Create jenkins-server on to the AWS (ec2 instance):-
--------------------------------------------------
Java&Maven&Docker  Installation
--------------------------------
sudo apt update (update the server)
sudo apt install openjdk-11-jdk -y (installing java)
java --version
sudo apt install maven -y (installing maven)
sudo apt install docker.io -y (installing docker)

Jenkins Installation
---------------------
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

Trivy Installation
-------------------
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y

Trivy Execution Commands
-------------------
trivy images imagename
trivy fs --security-check vuln,config Folder_name_OR_Path
trivy image --severity HIGH,CRITICAL image_name
trivy image -f html -o results.html image_name

trivy repo repo-url
trivy k8s --report summary cluster
https://github.com/jenkinsci/aqua-security-scanner-plugin/tree/master


Installing sonarqube-scanner (using docker container)
----------------------------
docker  run -d --name sonar -p 9000:9000 sonarqube:lts-community
deflut username:- admin
password:- admin
docker ps

Add Docker to jenkins group (before Build the docker images we should give this commands in gitbash)
---------------------------

sudo usermod -aG docker jenkins
sudo newgrp docker

restart the docker nd jenkins aswell

sudo systemctl restart docker 
sudo systemctl restart jenkins

CI-CD Pipeline

Install Requried Plugins in Jenkins CI-CD Pipelin
--------------------------------------------------

Eclipse Temurin installerVersion1.5 --> This plugin is for JDK11

Add JDK into globaltools section
Name jdk11
click install automatically --> Install from adoptium.net --> version jdk-11.0.19+7 --> apply and save

Add Maven tool into alobaltools section
Name maven3
click install automatically --> Install from Apache --> version 3.6.0 --> apply and save

SonarQube ScannerVersion 2.15 --> this plugin is for sonarqube scanner in jenkins ci-cd
->Open the sonarqube-server goto the adminitrastions section goto security then give the name for the toke then click the generate the token
ex :- squ_df1cb098b118517d0728cd17fc54316fed14aa38 (token)
->Then goto the globaltools create credit 
