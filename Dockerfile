FROM node:20-alpine

# --- Non-root user setup ---
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup

# --- App directory ---
WORKDIR /home/app

# --- Install dependencies ---
COPY package*.json ./
RUN npm ci --omit=dev

# --- Copy application code ---
COPY ./app .

# --- Copy entrypoint script ---
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# --- Fix ownership for non-root user ---
RUN chown -R appuser:appgroup /home/app

# --- Switch to non-root user ---
USER appuser

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["node", "server.js"]
