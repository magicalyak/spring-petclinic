# Spring PetClinic Sample Application

This project is based off https://github.com/spring-projects/spring-petclinic.git.

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

# License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).