FROM node:20-alpine

RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup

WORKDIR /home/app

COPY package*.json ./
RUN npm install --omit=dev

COPY ./app .

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chown -R appuser:appgroup /home/app
USER appuser

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["node", "server.js"]
