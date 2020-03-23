#!/bin/bash

# Current version info:
# commit d7dcffd2a68ca572c8bf0dd192624ed8cdc780e9
# Author: parkermac <p.maccready@gmail.com>
# Date:   Mon Jan 1 11:52:53 2018 -0800

version=d7dcffd2a68ca572c8bf0dd192624ed8cdc780e9

cd LiveOcean_roms

if [[ ! -e LO_ROMS ]] ; then

  echo "cloning the LiveOcean ROMS git repository - private"
  git clone https://github.com/parkermac/LO_ROMS.git
  #git clone git@github.com:parkermac/LO_ROMS.git
  if [ $? -eq 0 ]; then 
    cd LO_ROMS
    git checkout $version
    echo "LO_ROMS has been checked out... version: $version"
  else 
    echo "Unable to clone LO_ROMS repository"
    exit -1
  fi

else
  echo "LO_ROMS exists"
fi

