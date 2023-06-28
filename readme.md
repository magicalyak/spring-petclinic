# Spring PetClinic Sample Application

This project is based off https://github.com/spring-projects/spring-petclinic.git.

## Building with Jenkins

1. Install Jenkins on your local machine
2. Install the following dependencies on your local machine
    * Docker
    * Docker Compose
    * Maven
    * Java 11
3. Install the following security dependencies on your local machine
    * Trivy
    * OWASP Dependency Check
4. Enable the plugins for Jenkins (you may need to adjust the PATH Jenkins uses on a Mac)
    * Docker
    * Docker Pipeline
    * Pipeline
    * Pipeline Utility Steps
    * OWASP Dependency-Check
    * JFrog
5. Configure JFrog artifactory for containers and follow instructions to add the credentials to Jenkins
6. Create a pipeline job in Jenkins and point it to the Jenkinsfile in this repo
7. Run the pipeline job
8. Run a docker container with the image created by the pipeline job [gamull.jfrog.io/docker-local/spring-petclinic:3.1.0-SNAPSHOT](https://gamull.jfrog.io/artifactory/docker-local/spring-petclinic/3.1.0-SNAPSHOT/)
9. Visit [http://localhost:9090](http://localhost:9090) in your browser.

## Running petclinic locally with Docker

1. Install Docker on your local machine
2. build the docker container

```bash
docker build -t petclinic-app . -f Dockerfile
```

3. Run the container (we map port 8080 to 9090 because our local Jenkins uses 8080)

```bash
docker run -p 9090:8080 petclinic-app
```

4. Visit [http://localhost:9090](http://localhost:9090) in your browser.
5. Stop the container

```bash
docker stop petclinic-app
```

## Running petclinic locally with Docker Compose

1. Install Docker on your local machine
2. Run the container (we map port 8080 to 9090 because our local Jenkins uses 8080)

```bash 
docker-compose up
```

3. Visit [http://localhost:9090](http://localhost:9090) in your browser.
4. Stop the container

```bash
docker-compose down
```

## Database configuration

In its default configuration, Petclinic uses an in-memory database (H2) which
gets populated at startup with data. The h2 console is exposed at `http://localhost:8080/h2-console`,
and it is possible to inspect the content of the database using the `jdbc:h2:mem:testdb` url.
 
A similar setup is provided for MySQL and PostgreSQL if a persistent database configuration is needed. Note that whenever the database type changes, the app needs to run with a different profile: `spring.profiles.active=mysql` for MySQL or `spring.profiles.active=postgres` for PostgreSQL.

You can start MySQL or PostgreSQL locally with whatever installer works for your OS or use docker:

```
docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:8.0
```

or

```
docker run -e POSTGRES_USER=petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 postgres:15.2
```

Further documentation is provided for [MySQL](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/mysql/petclinic_db_setup_mysql.txt)
and for [PostgreSQL](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/postgres/petclinic_db_setup_postgres.txt).

Instead of vanilla `docker` you can also use the provided `docker-compose.yml` file to start the database containers. Each one has a profile just like the Spring profile:

```
$ docker-compose --profile mysql up
```

or

```
$ docker-compose --profile postgres up
```


# Security Hardening

## Trivy vulnerability scanning

We already have a synk version scan from docker in the JFrog pipeline but Trivy adds another layer and scans the code before we build the container.  This was easy to add to the Jenkinsfile and is represented below:

```groovy
        stage('Scan container with Trivy') {
            steps {
                script {
                    // Download HTML template
                    sh 'curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl > html.tpl'
                    // Scan Docker image for vulnerabilities
                    sh """
                        trivy image spring-petclinic:3.1.0-SNAPSHOT --format template --template @./html.tpl --output trivy_report.html
                    """
                }
            }
        }
```

## OWASP Dependency Check



## Managing Secrets

We could leverage Hasicorp Vault for storing access tokens, passwords and logins.  This project did not integrate that but it is a good idea to consider for future projects.

## SonarQube

SonarQube is a static code analysis tool that can be used to find bugs, vulnerabilities and code smells.  It is a good idea to run this tool on your code before you build your container.  This project did not integrate SonarQube but it is a good idea to consider for future projects.

## Snyk

Snyk is a tool that can be used to find vulnerabilities in your code.  It is a good idea to run this tool on your code before you build your container.  This project did integrated Synk using the built in Docker scan function.

```groovy
        stage('Push image to Artifactory') {
            steps {
                dir('docker-oci-examples/spring-petclinic/') {
                    // Scan Docker image for vulnerabilities
                    jf 'docker scan $DOCKER_IMAGE_NAME'

                    // Push image to Artifactory
                    jf 'docker push $DOCKER_IMAGE_NAME'
                }
            }
        }
```

## JFrog Artifactory

JFrog Artifactory is a tool that can be used to store your container images.  It is a good idea to store your container images in a secure repository.  This project leveraged JFrog Artifactory to store the built docker image.

# License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).