#!/bin/bash -e

PROJECT="$(basename `pwd`)"
BUCKET="existing-s3-bucket"
REGION="eu-west-1"

init() {
  if [ -d .terraform ]; then
    if [ -e .terraform/terraform.tfstate ]; then
      echo "Remote state already exists!"
      if [ -z $IGNORE_INIT ]; then
        exit 1
      fi
    fi
  fi

  terraform remote config \
    -backend=s3 \
    -backend-config="bucket=${BUCKET}" \
    -backend-config="key=${PROJECT}/terraform.tfstate" \
    -backend-config="region=${REGION}"

}

while getopts "i" opt; do
  case "$opt" in
    i)
      IGNORE_INIT="true"
      ;;
  esac
done

shift $((OPTIND-1))

init
