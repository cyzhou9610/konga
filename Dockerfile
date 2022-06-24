FROM node:12.16.3-alpine

COPY . /app

WORKDIR /app
#RUN npm install -g cnpm --registry=https://registry.npm.taobao.org
RUN apk upgrade --update
RUN apk add bash git ca-certificates
RUN apk add --no-cache python2 \
    && apk add make \
    && apk add g++
RUN npm install -g bower
RUN npm --unsafe-perm --production install
RUN rm -rf /var/cache/apk/* \
        /app/.git \
        /app/screenshots \
        /app/test
RUN adduser -H -S -g "Konga service owner" -D -u 1200 -s /sbin/nologin konga \
    && mkdir /app/.tmp \ 
    && chown -R 1200:1200 /app/views /app/kongadata /app/.tmp
RUN apk del python2 \
    && apk del git \
    && apk del make \
    && apk del g++
EXPOSE 1337

VOLUME /app/kongadata

ENTRYPOINT ["/app/start.sh"]
