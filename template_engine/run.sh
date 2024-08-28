#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DEST="/work/dest"
SRC="/work/templates"
PARAM="/work/param.yaml"
INSTANCES=`yq 'keys_unsorted' ${PARAM} | jq -r '.[]'`

create_include () {
  instance=$1
  dir=${DEST}/${instance}
  params=$2
  mkdir -p ${dir}
  echo $params | base64 -d | yq -s -y -M '.[0] * .[1]' /work/default.yaml - > ${dir}/params_in.yaml
  mustache ${dir}/params_in.yaml /work/templates/instance/instance.env > ${dir}/${instance}.env
  # mustache ${dir}/params_in.yaml /work/templates/instance/compose.yaml > ${dir}/compose.yaml
  mustache ${dir}/params_in.yaml /work/templates/instance/compose_nossl.yaml > ${dir}/compose.yaml
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
  yq -y -M 'keys_unsorted' ${PARAM} > $tmpfile
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
    create_include ${instance} $(yq -y -M .${instance} ${PARAM} | base64 -w 0)
  else
    echo '"'${instance}'"' not changed because of external changes
    failed=$((failed+1))
  fi
done;

create_include_file



#INSTANCES = `yq 'keys_unsorted' instances.yaml | jq -r '.[]'`

#yq -y -M '.develop' instances.yaml | base64 -w 0

# iterate every key in paramaters
# create dir if not exists
# crater file from template to temp dir
# create sha256 of genarted file
# copy if no file exitst to dest
# copy if fingerprint matches: else file is modified
# if file is modified copy file and fingerprint if overrwite flag ist set

