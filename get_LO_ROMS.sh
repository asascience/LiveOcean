#!/bin/bash

TOPDIR=${PWD}

# LO:
LOCOMMIT=b615de741f92ac70d77ff6062e12d556bb36738c

# Parker's LO_roms_user:
# LORUCOMMIT=a54c32a2302c32d724f97c7687042890116b4600

# RPS fork
# commit 
# Date:
# LORUCOMMIT=

# LO_roms_source_alt
LORSACOMMIT=4c38c448ba1328bc221430b5963dfa71a6dcc23b

# ROMS
# Revision: 1170
# Last Changed Rev: 1170
# Last Changed Date: 2023-06-04 20:11:16 +0000 (Sun, 04 Jun 2023)
#ROMSVERSION=1170
ROMSSVNVERSION=1205
ROMSGITVERSION=fb0275c5

echo "cloning the LiveOcean ROMS git repositories"

git clone https://github.com/parkermac/LO.git
cd LO
#git checkout $LOCOMMIT
cd $TOPDIR

# RPS fork with build fix
git clone https://github.com/asascience/LO_roms_user.git
cd LO_roms_user/
git checkout ioos-cloud
cd $TOPDIR

git clone https://github.com/parkermac/LO_roms_source_alt.git
cd LO_roms_source_alt
#git checkout $LORSACOMMIT
cd $TOPDIR

# ROMS SRC git
git clone https://github.com/myroms/roms.git ./LO_roms_source_git
cd LO_roms_source_git
git checkout $ROMSGITVERSION

