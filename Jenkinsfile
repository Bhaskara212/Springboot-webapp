pipeline {
    agent any
    tools {
        jdk 'jdk11'
        maven 'maven3'
    }
	  parameters{
	
        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
	
	  }
	
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  git 'https://github.com/Bhaskara212/Springboot-webapp.git'
				}
            }
        }
        
        stage('Code Complie') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  sh 'mvn clean compile'
				}
            }
        }
        
        stage('Code Analysis') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  withSonarQubeEnv('sonar-scanner') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Springboot-CICD \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=Springboot-CICD '''
				  }
                }
            }
        }
        
        
        stage('Build the code') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  sh 'mvn clean install'
				}
            }
        }
		
		stage('Build the Docker File') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                   sh 'docker build -t krishna21290/springboot-web:1.0 .'
                }      
            }
        }
		stage('push the Docker Image to docker hub') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                   withCredentials([string(credentialsId: 'docker-hub-password', variable: 'dockerhubpassword')]) {
                    sh "docker login -u krishna21290 -p ${dockerhubpassword}"
                    sh 'docker push krishna21290/springboot-web:1.0'
                   }
                }
                
            }
        }
		stage('Trivy FS Scan') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  sh "trivy fs ."
				}  
            }
        }
		stage('Deploy to K8's') {
            when { expression {  params.action == 'create' } }
            steps{
                script{
                  kubernetesDeploy(configs:'Deployment.yaml', kubeconfigId:'kubernetes') 
				}  
            }
        }
    }
}
