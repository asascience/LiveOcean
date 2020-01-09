#!/bin/bash

# Current version info:
# commit d7dcffd2a68ca572c8bf0dd192624ed8cdc780e9
# Author: parkermac <p.maccready@gmail.com>
# Date:   Mon Jan 1 11:52:53 2018 -0800

version=d7dcffd2a68ca572c8bf0dd192624ed8cdc780e9

if [[ ! -e LO_ROMS ]] ; then
  echo "cloning the LiveOcean ROMS git repository - private"
  git clone https://github.com/parkermac/LO_ROMS.git
  cd LO_ROMS
  git checkout $version
else
  echo "LO_ROMS exists"
fi

