node {
    stage("Clone the project") {
        git branch: 'main', url: 'https://github.com/magicalyak/spring-petclinic.git'
    }

    stage("Completion") {
        sh "./mvnw clean install -DskipTests"
    }

    stage("Tests and Deployment") {
        stage("Running unit tests") {
            sh "./mvnw test -Punit"
        }
        stage("Deployment") {
            sh 'nohup ./mvnw spring-boot:run -Dserver.port=8001 &'
        }
    }
}