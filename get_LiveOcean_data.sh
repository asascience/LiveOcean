#!/bin/bash

# This will retrieve the various fixed field datasets from S3 or other storage.
# These filesets are too large to store on GitHhub.
# Currently, the first dataset LiveOcean_data/grids/cas6 is stored on GitHub using git-lfs. 
# But, there is a 1GB free limit.
# 
# For now, this method is being setup as an alternative for the future.
#
# Patrick Tripp - January 9, 2020

datasets='
  LiveOcean_data.grids.cas6.tgz
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
    aws s3 cp s3://${bucket}/${key} .
    # tar -xvf $file
    # rm $file
  done
fi


