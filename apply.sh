#!/bin/bash

set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "** Simplifier docker multi-instance setup **"
echo ""

usage () {
    echo "usage: $0 [-fh] -p parameter_file.yaml"
    echo "  -h                  show help text"
    echo "  -f                  force overwrite"
    echo "  -p parameter_file   use <parameter_file>"
}

FORCE_OVERWRITE=0
while getopts ":p:fh" a; do
    case "${a}" in
        p)
            PARAMETER_FILE=$(realpath ${OPTARG})
            ;;
        f)
            FORCE_OVERWRITE=1
            ;;
        h)
            usage
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${PARAMETER_FILE}" ] ; then
    echo "missing '-p' with parameter file"
    usage
    exit 1
fi

if [ ! -f "${PARAMETER_FILE}" ]; then
    echo "missing parameter file: '${PARAMETER_FILE}'"
    exit 1
fi

echo "create instances defined in: ${PARAMETER_FILE}"

(cd ${DIR} && docker compose down)

if [ $FORCE_OVERWRITE -eq "1" ]; then
    echo "force overwrite existing configuration"
    ${DIR}/template_engine/execute.sh -p ${PARAMETER_FILE} -f
else
    ${DIR}/template_engine/execute.sh -p ${PARAMETER_FILE}
fi

(cd ${DIR} && docker compose up -d)
