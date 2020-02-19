
FROM alpine/git as clone 
WORKDIR /app
RUN git clone https://github.com/spring-projects/spring-petclinic.git

FROM maven:3.5-jdk-8-alpine as build 
WORKDIR /app
COPY --from=clone /app/spring-petclinic /app 
RUN mvn install

FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar /app

RUN mkdir /opt/contrastsecurity
ADD ./contrast.jar /opt/contrastsecurity
EXPOSE 8080
CMD ["java","-javaagent:/opt/contrastsecurity/contrast.jar","-Dcontrast.agent.java.standalone_app_name=Spring-Petclinic-Docker","-Dcontrast.server.name=RajMAC","-jar","/app/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]

