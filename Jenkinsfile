pipeline {
	agent any
	tools {
		jfrog 'jfrog-cli'
	}
	environment {
		DOCKER_IMAGE_NAME = "gamull.jfrog.io/docker-local/spring-petclinic:3.1.0-SNAPSHOT"
	}
	stages {
		stage('Clone') {
			steps {
				git branch: 'main', url: "https://github.com/magicalyak/spring-petclinic.git"
			}
		}

        stage('Compile the code') {
            steps {
                sh './mvnw clean install -DskipTests'
            }
        }

        stage("Run the tests") {
            steps {
                sh './mvnw test -Punit'
            }
        }

        // stage("Deployment") {
        //     steps {
        //         sh 'nohup ./mvnw spring-boot:run -Dserver.port=8001 &'
        //     }
        // }

        stage("Package the application") {
            steps {
                sh './mvnw spring-boot:build-image'

                // //Tag Image
                jf 'docker tag spring-petclinic:3.1.0-SNAPSHOT $DOCKER_IMAGE_NAME'
            }
        }

        stage('Scan container with Trivy') {
            steps {
                script {
                    sh 'trivy image --format template --template html.tpl --output trivy_report.html spring-petclinic:3.1.0-SNAPSHOT'
                }
                
            }
        }

		stage('Push image to Artifactory') {
			steps {
				dir('docker-oci-examples/spring-petclinic/') {
					// Scan Docker image for vulnerabilities
					// jf 'docker scan $DOCKER_IMAGE_NAME'

					// Push image to Artifactory
					jf 'docker push $DOCKER_IMAGE_NAME'
				}
			}
		}

		stage('Publish build info') {
			steps {
				jf 'rt build-publish'
			}
		}
	}
}