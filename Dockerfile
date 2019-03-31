FROM maven:3-jdk-11-slim as sourcebuilder

ENV BLYNK_SERVER_VERSION 0.41.5

RUN apt-get update                 && \
    apt-get install -y wget vim    && \
    cd ~                           && \
    wget -q -O ~/blynk-client.tar.gz "https://github.com/blynkkk/blynk-server/archive/v${BLYNK_SERVER_VERSION}.tar.gz" && \
    tar zxf ~/blynk-client.tar.gz  && \
    cd ~/blynk-server-${BLYNK_SERVER_VERSION}    && \
    mvn clean install -Dmaven.test.skip=true     && \
    cp ~/.m2/repository/cc/blynk/client/${BLYNK_SERVER_VERSION}/client-${BLYNK_SERVER_VERSION}.jar ~/blynk-client.jar

### Final Dockerfile

FROM adoptopenjdk/openjdk11:jdk-11.0.2.9-alpine-slim
MAINTAINER Christos Manios <maniopaido@gmail.com>

LABEL name="Blynk Client" \
      version="0.41.5" \
      homepage="http://www.blynk.cc/" \
      maintainer="Christos Manios <maniopaido@gmail.com>"

COPY --from=sourcebuilder /root/blynk-client.jar /

CMD ["java", "-jar", "/blynk-client.jar"]
