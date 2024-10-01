#!/bin/bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

FORCE_OVERWRITE=0
while getopts ":t:p:d:f" a; do
    case "${a}" in
        t)
            TEMPLATE_DIR=$(realpath ${OPTARG})
            ;;
        p)
            PARAMETER_FILE=$(realpath ${OPTARG})
            ;;
        d)
            DESTINATION_DIR=$(realpath ${OPTARG})
            ;;
        f)
            FORCE_OVERWRITE=1
            ;;
        *)
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${PARAMETER_FILE}" ] ; then
    echo "missing '-p' with parameter file"
    exit 1
fi

if [ -z "${TEMPLATE_DIR}" ] ; then
    TEMPLATE_DIR=$(realpath ${DIR}/../templates)
fi

if [ -z "${DESTINATION_DIR}" ]; then
    DESTINATION_DIR=$(realpath ${DIR}/../include)
fi

TRAEFIK_DIR=$(realpath /var/lib/simplifier/traefik)

if [ ! -d "${TEMPLATE_DIR}" ]; then
    echo "missing template directory: '${TEMPLATE_DIR}'"
    exit 1
fi

if [ ! -d "${DESTINATION_DIR}" ]; then
    echo "missing destination directory: '${DESTINATION_DIR}'"
    exit 1
fi

if [ ! -f "${PARAMETER_FILE}" ]; then
    echo "missing parameter file: '${PARAMETER_FILE}'"
    exit 1
fi

template_container_name="template_container"

docker build -t ${template_container_name} ${DIR}
docker run --rm \
  -v ${TEMPLATE_DIR}:/work/templates:ro \
  -v ${DESTINATION_DIR}:/work/dest:rw \
  -v ${TRAEFIK_DIR}:/work/dest_traefik:rw \
  -v ${PARAMETER_FILE}:/work/param.yaml:ro \
  -v ${DIR}/../instance_default.yaml:/work/default.yaml:ro \
  -e OVERWRITE=${FORCE_OVERWRITE} \
  -e USERID=$UID \
  ${template_container_name} /work/run.sh

