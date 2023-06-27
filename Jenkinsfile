node {
    stage("Clone the project") {
        git branch: 'main', url: 'https://github.com/magicalyak/spring-petclinic.git'
    }

    stage("Compile the code") {
        sh "./mvnw clean install -DskipTests"
    }

    stage("Tests and Deployment") {
        stage("Run the tests") {
            sh "./mvnw test -Punit"
        }
        // stage("Deployment") {
        //     sh 'nohup ./mvnw spring-boot:run -Dserver.port=8001 &'
        // }
        stage("Package the application") {
            sh "./mvnw spring-boot:build-image"
        }
    }
}