#!/bin/sh
# Container entrypoint for the profile app.
#
# Runs start-up checks, then hands off to the container's CMD
# (by default `node server.js`) via `exec "$@"`, so the Node process
# becomes PID 1 and receives signals (e.g. SIGTERM from `docker stop`).
#
# Note: node:20-alpine has no bash, so this script is POSIX sh.

# Exit on any error or use of an unset variable.
set -eu

log() {
  echo "[entrypoint] $*"
}

# --- 1. Check required environment variables ------------------------------
# These are needed by app/db/index.js and app/server.js.
missing=""
for var in MONGO_USER MONGO_PASS MONGO_HOST MONGO_PORT PORT; do
  eval "value=\${$var:-}"
  if [ -z "$value" ]; then
    missing="$missing $var"
  fi
done

if [ -n "$missing" ]; then
  log "ERROR: missing required environment variable(s):$missing"
  log "Pass them with 'docker run -e VAR=value' or the 'environment:' key in Compose."
  exit 1
fi

# --- 2. Check the profile picture exists -----------------------------------
if [ ! -f "./images/${IMAGE:-}.jpg" ]; then
  log "WARNING: ./images/${IMAGE:-<IMAGE unset>}.jpg not found - /profile-picture will fail."
fi

# --- 3. Wait for MongoDB to accept connections -----------------------------
# Poll Mongo's port before starting the app.
WAIT_TIMEOUT="${WAIT_TIMEOUT:-30}"
log "Waiting up to ${WAIT_TIMEOUT}s for MongoDB at ${MONGO_HOST}:${MONGO_PORT}..."

elapsed=0
until node -e "
  require('net')
    .connect(process.env.MONGO_PORT, process.env.MONGO_HOST)
    .on('connect', () => process.exit(0))
    .on('error', () => process.exit(1));
" 2>/dev/null; do
  elapsed=$((elapsed + 1))
  if [ "$elapsed" -ge "$WAIT_TIMEOUT" ]; then
    log "ERROR: MongoDB not reachable after ${WAIT_TIMEOUT}s."
    exit 1
  fi
  sleep 1
done
log "MongoDB is reachable."

# --- 4. Start the app -------------------------------------------------------
log "Starting: $*"
exec "$@"
