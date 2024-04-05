#!/bin/bash
# set -x

# This will retrieve the various fixed field datasets from S3 or other storage.
# These filesets are too large to store on GitHhub.

# forcing goes in: LO_output
# restart file and forecast output goes in: LO_roms

datasets='
  LO_data.grids.cas7.v1.3.tgz
  LO_roms.f2012.10.07.restart.cas7.tgz
'
#  LO_output.f2017.06.01.forcing.v1.3.tgz
#  LO_roms.f2017.05.31.restart.v1.3.tgz

bucket="ioos-sandbox-use2/public/LiveOcean"

# Default behavior is to retrieve (no args)
cd /com/$USER

for file in $datasets
do
  key=$file
  #aws s3 cp $file s3://${bucket}/${key} --acl public-read
  if [[ $# -eq 1 && $1 == 'store' ]] ; then
    aws s3 cp $file s3://${bucket}/${key}
  else
    aws s3 cp s3://${bucket}/${key} .
    tar -xvf $file
    rm $file
  fi
done

