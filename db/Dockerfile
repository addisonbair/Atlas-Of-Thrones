FROM mdillon/postgis:9.6-alpine

RUN apk add --update \
    ca-certificates \
    wget \
&& rm -rf /var/cache/apk/*

COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/
