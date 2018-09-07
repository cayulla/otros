FROM ubuntu:16.04

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JHIPSTER_SLEEP=0 \
    JAVA_OPTS=""

# Add a jhipster user to run our application so that it doesn't need to run as root
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN adduser --disabled-password --system /bin/sh jhipster && \
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
sudo apt-get update && \
sudo apt-get install -y mongodb-org && \
sudo service mongod start

WORKDIR /home/jhipster

ADD entrypoint.sh entrypoint.sh
RUN chmod 755 entrypoint.sh && chown jhipster:jhipster entrypoint.sh
USER jhipster

ADD *.war app.war

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8080 5701/udp

