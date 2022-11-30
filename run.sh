#!/bin/sh

/bin/echo "Starting nanomdm ..."

execServe="/usr/local/bin/nanomdm"

./nanomdm-darwin-amd64 -ca ca.pem -api nanomdm -debug

# CA Cert path
if [[ ${CAPATH} ]]; then
  execServe="${execServe} -capass ${CAPASS}"
fi

# API Key - Required
if [[ ! ${API_KEY} ]]; then
  /bin/echo "No API Key Set - Exiting"
  exit 1
else
  execServe="${execServe} -api ${API_KEY}"
fi

# Set debug
if [[ "${DEBUG}" = "true" ]]; then
  execServe="${execServe} -debug"
fi

# DSN - Required
if [[ ! ${DBUSER} ]] && [[ ! ${DBPASS} ]] && [[ ! ${DBNAME} ]]; then
  /bin/echo "Cannot set DSN - Exiting"
  exit 1
else
  execServe="${execServe} -dsn '${DBUSER}:${DBPASS}@tcp(${DBHOST:=127.0.0.1}:${DBPORT:=3306})/${DBNAME}'"
fi

# Port to listen on (default ":9000")
if [[ ${LISTEN} ]]; then
  execServe="${execServe} -listen ${LISTEN}"
fi

# Webhook URL
if [[ ${WEBHOOK_URL} ]]; then
  execServe="${execServe} -webhook-url ${WEBHOOK_URL}"
fi

echo "Starting using: $execServe"

eval $execServe
