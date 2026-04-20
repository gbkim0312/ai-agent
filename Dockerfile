FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /build

COPY web/pom.xml web/pom.xml
COPY web/src web/src

RUN mvn -f web/pom.xml -DskipTests package

FROM eclipse-temurin:21-jre

WORKDIR /app

ENV SERVER_PORT=8081

COPY --from=build /build/web/target/agent-web-platform-0.1.0-SNAPSHOT.jar /app/app.jar

RUN mkdir -p /app/data

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/app.jar"]