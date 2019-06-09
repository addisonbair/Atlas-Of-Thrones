FROM mdillon/postgis:9.6-alpine

RUN apk add --update \
    ca-certificates \
    wget \
&& rm -rf /var/cache/apk/*

COPY ./load_db.sh /docker-entrypoint-initdb.d/load_db.sh
