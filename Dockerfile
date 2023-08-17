FROM openjdk:11
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} springboot-webapp.jar
ENTRYPOINT ["java","-jar","springboot-webapp.jar"]
