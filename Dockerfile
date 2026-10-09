FROM node:20-alpine

ENV MONGO_USER='admin' \
    MONGO_PASS='' \
    MONGO_HOST='' \
    MONGO_PORT=27017 \
    APP_HOST='' \
    PORT=3000

WORKDIR /home/app

COPY ./app/package*.json ./
RUN npm ci --omit=dev

COPY ./app .
EXPOSE 3000

CMD ["node", "server.js"]
