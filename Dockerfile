FROM rockylinux:9.0
LABEL petclinic 2.7.3
RUN dnf install --assumeyes java-17-openjdk
RUN dnf clean all
EXPOSE 8080/tcp
ADD target/spring-petclinic-3.1.0-SNAPSHOT.jar spring.jar
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-17.0.5.0.8-2.el8_6.x86_64
RUN export JAVA_HOME
ENV database mysql
ENV MYSQL_URL "jdbc:mysql://$database/petclinic"
ENV MYSQL_USER petclinic
ENV MYSQL_PASS petclinic
RUN export database
RUN export MYSQL_URL
RUN export MYSQL_USER
RUN export MYSQL_PASS
ENTRYPOINT ["java","-jar","/spring.jar","--spring.profiles.active=mysql"]
