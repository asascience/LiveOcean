#!/bin/bash
set -x

# This will retrieve the various fixed field datasets from S3 or other storage.
# These filesets are too large to store on GitHhub.

datasets='
  LO_data.grids.cas6.v1.3.tgz
'

bucket="ioos-cloud-sandbox"

# Default behavior is to retrieve (no args)
if [[ $# -eq 1 && $1 == 'store' ]] ; then
  for file in $datasets
  do
    key=LiveOcean/grids/$file
    aws s3 cp $file s3://${bucket}/${key}
  done
else
  for file in $datasets
  do
    key=LiveOcean/grids/$file
    #[ -s $file ] && aws s3 cp s3://${bucket}/${key} .
    aws s3 cp s3://${bucket}/${key} .
    tar -xvf $file
  done
fi


