#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DEST="/work/dest"
DEST_TRAEFIK="/work/dest_traefik"
SRC="/work/templates"
PARAM="/work/param.yaml"
PARAM_TRAEFIK="${DEST}/param_traefik.yaml"

CONFIG_DIR_TRAEFIK="${DEST_TRAEFIK}/configuration"
CERTS_DIR_TRAEFIK="${DEST_TRAEFIK}/certs"

mkdir -p ${CONFIG_DIR_TRAEFIK} ${CERTS_DIR_TRAEFIK}
INSTANCES=`yq '.instances' ${PARAM}|  yq 'keys_unsorted' | jq -r '.[]'`
HAS_SSL=$(yq 'has("secure")' ${PARAM})
SSL_CERT_TYPE="N/A"
if [ ${HAS_SSL} = "true" ]; then
  type=$(yq -r .secure.type ${PARAM} | tr '[:upper:]' '[:lower:]')
  case ${type} in
    "custom")
      SSL_CERT_TYPE=${type}
      ;;
    "letsencrypt")
      SSL_CERT_TYPE=${type}
      ;;
    *)
      echo unknown certification method ${type}
      exit 1
      ;;
  esac
fi
echo "ssl config: "
echo "  - has ssl: $HAS_SSL"
echo "  - ssl type: $SSL_CERT_TYPE"
echo "____________________________"


create_ssl_config_for_traefik () {
  rm -f ${CONFIG_DIR_TRAEFIK}/${domain_suffix}.key ${CONFIG_DIR_TRAEFIK}/${domain_suffix}.crt ${CONFIG_DIR_TRAEFIK}/fingerprints.sha256 ${CONFIG_DIR_TRAEFIK}/security.toml
  if [[ ${SSL_CERT_TYPE} == "custom" ]]; then
    domain_suffix=$(yq -r .domain_suffix ${PARAM})
    mustache ${PARAM} /work/templates/traefik_config/security.toml > ${CONFIG_DIR_TRAEFIK}/security.toml
    yq -r .secure.key ${PARAM} > ${CONFIG_DIR_TRAEFIK}/${domain_suffix}.key
    yq -r .secure.wildcard_crt_for_domain_suffix ${PARAM} > ${CONFIG_DIR_TRAEFIK}/${domain_suffix}.crt
    (cd ${CONFIG_DIR_TRAEFIK} && sha256sum security.toml ${domain_suffix}.crt ${domain_suffix}.key > ${CONFIG_DIR_TRAEFIK}/fingerprints.sha256)
  fi
  if [[ ${SSL_TYPE} == "letsencrypt" ]]; then
    mkdir -p  ${CERTS_DIR_TRAEFIK}
  fi
}

check_if_ssl_config_for_traefik_modified () {
  mkdir -p ${CONFIG_DIR_TRAEFIK}
  if [ ! -f ${CONFIG_DIR_TRAEFIK}/fingerprints.sha256 ]; then
    return 0
  fi
  (cd ${CONFIG_DIR_TRAEFIK} && sha256sum --status -c ./fingerprints.sha256)
  return $?
}

create_params_for_traefik () {
  echo "exposed_debugging_ports:" > ${PARAM_TRAEFIK}
  for instance in ${INSTANCES}; do
    echo "  -" $(yq -r .instances.${instance}.exposed_debugging_port ${PARAM}) >> ${PARAM_TRAEFIK}
  done;
  if [ ${HAS_SSL} = "true" ]; then
    yq -y -M .secure ${PARAM} >> ${PARAM_TRAEFIK}
  fi
}

create_include () {
  instance=$1
  dir=${DEST}/${instance}
  params=$2
  host_suffix=$3
  mkdir -p ${dir}
  echo $params | base64 -d | yq -s -y -M '.[0] * .[1]' /work/default.yaml - > ${dir}/params_in.yaml
  hostname=`yq -r .simplifier_subdomain ${dir}/params_in.yaml`.${host_suffix}
  param_content=`echo 'simplifier_hostname: '$hostname | yq -s -y -M '.[0] * .[1]' ${dir}/params_in.yaml - | base64 -w 0`
  echo $param_content | base64 -d > ${dir}/params_in.yaml
  mustache ${dir}/params_in.yaml /work/templates/instance/instance.env > ${dir}/${instance}.env
  if [ ${HAS_SSL} = "true" ]; then
    case ${SSL_CERT_TYPE} in
      "custom")
        mustache ${dir}/params_in.yaml /work/templates/instance/compose.yaml > ${dir}/compose.yaml
        ;;
      "letsencrypt")
        mustache ${dir}/params_in.yaml /work/templates/instance/compose_letsencrypt.yaml > ${dir}/compose.yaml
        ;;
      *)
        echo unknown certification method ${SSL_CERT_TYPE}
        exit 1
        ;;
    esac
  else
    mustache ${dir}/params_in.yaml /work/templates/instance/compose_nossl.yaml > ${dir}/compose.yaml
  fi

  mkdir -p ${dir}/mysql
  mustache ${dir}/params_in.yaml /work/templates/instance/mysql/config.yaml > ${dir}/mysql/config.yaml
  (cd ${dir} && sha256sum params_in.yaml ${instance}.env compose.yaml mysql/config.yaml > ${dir}/fingerprints.sha256)
  chown -R ${USERID} ${dir}
}

check_if_modified () {
  instance=$1
  dir=${DEST}/${instance}
  mkdir -p ${dir}
  if [ ! -f ${dir}/fingerprints.sha256 ]; then
    return 0
  fi
  (cd ${dir} && sha256sum --status -c ./fingerprints.sha256)
  return $?
}

create_include_file () {
  tmpfile=$(mktemp /tmp/instance_list.XXXXXX)
  yq '.instances' ${PARAM}| yq -y -M 'keys_unsorted' > $tmpfile
  mustache $tmpfile /work/templates/include.yaml > ${DEST}/include.yaml
  rm -f $tmpfile
}

failed=0

for instance in ${INSTANCES}; do
  if [ $OVERWRITE -eq "0" ]; then
    check_if_modified ${instance}
    check=$?
  else
    check=0
  fi
  if [ $check -eq "0" ]; then
    suffix=`yq -r .domain_suffix ${PARAM}`
    create_include ${instance} $(yq -y -M .instances.${instance} ${PARAM} | base64 -w 0) $suffix
  else
    echo '"'${instance}'"' not changed because of external changes
    failed=$((failed+1))
  fi
done;

if [ $failed -eq "0" ]; then
  create_params_for_traefik

  if [ ${HAS_SSL} = "true" ]; then
    case ${SSL_CERT_TYPE} in
      "custom")
        mustache ${PARAM_TRAEFIK} /work/templates/traefik.yaml > ${DEST}/traefik.yaml
        ;;
      "letsencrypt")
        mustache ${PARAM_TRAEFIK} /work/templates/traefik_letsencrypt.yaml > ${DEST}/traefik.yaml
        ;;
      *)
        echo unknown certification method ${SSL_CERT_TYPE}
        exit 1
        ;;
    esac
  else
    mustache ${PARAM_TRAEFIK} /work/templates/traefik_nossl.yaml > ${DEST}/traefik.yaml
  fi
  if [ ${HAS_SSL} = "true" ]; then
    if [ $OVERWRITE -eq "0" ]; then
      check_if_ssl_config_for_traefik_modified
      check=$?
      if [ $check -eq "0" ]; then
        create_ssl_config_for_traefik
      else
        echo traefik security not changed because of external changes
      fi
    else
      create_ssl_config_for_traefik
    fi
  fi

fi

create_include_file


