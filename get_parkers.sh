#!/usr/bin/env bash

cd /com/$user
mkdir apogee
cd apogee
aws s3 cp s3://ioos-cloud-sandbox/public/LiveOcean/apogee.f2017.06.01.tgz .
tar -xvf apogee.f2017.06.01.tgz
rm apogee.f2017.06.01.tgz
