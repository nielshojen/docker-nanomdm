#!/bin/sh

/bin/echo "Starting nanomdm ..."

execServe="/usr/local/bin/nanomdm"

# CA Cert path
if [[ ${CAPATH} ]]; then
  execServe="${execServe} -ca ${CAPATH}"
fi

# CA Cert path
if [[ ${CAPATH} ]] && [[ ${SCEP_URL} ]]; then
  apk add openssl
  curl '${SCEP_URL}/scep?operation=GetCACert' | openssl x509 -inform DER > ${CAPATH}
  apk del openssl
fi

# API Key - Required
if [[ ! ${MDM_API_KEY} ]]; then
  /bin/echo "No API Key Set - Exiting"
  exit 1
else
  execServe="${execServe} -api ${MDM_API_KEY}"
fi

# Set debug
if [[ "${DEBUG}" = "true" ]]; then
  execServe="${execServe} -debug"
fi

# DSN - Required
if [[ ! ${MDM_DBUSER} ]] && [[ ! ${MDM_DBPASS} ]] && [[ ! ${MDM_DBNAME} ]]; then
  /bin/echo "Cannot set DSN - Exiting"
  exit 1
else
  execServe="${execServe} -storage mysql -storage-dsn '${MDM_DBUSER}:${MDM_DBPASS}@tcp(${DBHOST:=127.0.0.1}:${DBPORT:=3306})/${MDM_DBNAME}'"
fi

# Declarative Management
if [[ ${DM} ]]; then
  execServe="${execServe} -dm ${DM}"
fi

# Port to listen on (default ":9000")
if [[ ${LISTEN} ]]; then
  execServe="${execServe} -listen ${LISTEN}"
fi

# Webhook URL
if [[ ${WEBHOOK_URL} ]]; then
  execServe="${execServe} -webhook-url ${WEBHOOK_URL}"
fi

# Webhook URL
if [[ ${MIGRATION} ]]; then
  execServe="${execServe} -migration"
fi

echo "Starting using: $execServe"

eval $execServe
