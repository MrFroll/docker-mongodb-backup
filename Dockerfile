FROM ubuntu:20.04

LABEL maintainer="inbox@mrfroll.com"

ENV DEBIAN_FRONTEND=noninteractive

COPY ./bin/backup.sh /usr/local/bin/ 

RUN mkdir -p /mongo_backup /raw_files \
  && chmod u+x /usr/local/bin/backup.sh \
  && touch /var/log/mongo_backup.log
  
RUN apt update && apt install -y wget gnupg awscli\
  && wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
  && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
  && apt update && apt install -y  mongodb-org-shell mongodb-org-tools

ENTRYPOINT ["/usr/local/bin/backup.sh"]
