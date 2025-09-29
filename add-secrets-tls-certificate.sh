#!/bin/sh

set namespace,secret_name,ssl_path

readVariables() {
  read -p "Type namespace: " namespace
  read -p "Type secret name: " secret_name
  read -p "Type cert path[]: " ssl_path
}

verifyVariables() {
  if [[ -z $namespace ]]
  then
    echo "Namespace is mandatory"
  fi

  if [[ -z $secret_name ]]
  then
    echo "Secrete name is mandatory"
  fi

  if [[ -z $ssl_path ]]
  then
    echo "SSL_path is mandatory"
  fi
}

createTlsSecrets() {
  kubectl -n ${namespace} create secret tls ${secret_name} \
    --cert=${ssl_path}/fullchain.pem \
    --key=${ssl_path}/privkey.pem
}



readVariables
verifyVariables
createTlsSecrets
