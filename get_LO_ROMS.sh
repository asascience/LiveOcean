#!/bin/bash

TOPDIR=${PWD}

# LO:
# commit b615de741f92ac70d77ff6062e12d556bb36738c
# Date:   Thu Jun 8 12:28:59 2023 -0700
LOCOMMIT=b615de741f92ac70d77ff6062e12d556bb36738c

# Parker's LO_roms_user:
# commit a54c32a2302c32d724f97c7687042890116b4600
# Date:   Sun May 14 15:21:03 2023 -0700
# LORUCOMMIT=a54c32a2302c32d724f97c7687042890116b4600

# RPS fork
# commit 
# Date:
# LORUCOMMIT=

# LO_roms_source_alt
# commit 4c38c448ba1328bc221430b5963dfa71a6dcc23b
# Date:   Tue May 2 08:03:29 2023 -0700
LORSACOMMIT=4c38c448ba1328bc221430b5963dfa71a6dcc23b

# ROMS
# Revision: 1170
# Last Changed Rev: 1170
# Last Changed Date: 2023-06-04 20:11:16 +0000 (Sun, 04 Jun 2023)
ROMSVERSION=1170

echo "cloning the LiveOcean ROMS git repositories"

git clone https://github.com/parkermac/LO.git
cd LO
git checkout $LOCOMMIT
cd $TOPDIR

# Parker's main
# git clone https://github.com/parkermac/LO_roms_user.git
# cd LO_roms_user
# git checkout $LORUCOMMIT
# cd $TOPDIR

# RPS fork with build fix
git clone https://github.com/asascience/LO_roms_user.git
cd LO_roms_user/
git checkout ioos-cloud
cd $TOPDIR

git clone https://github.com/parkermac/LO_roms_source_alt.git
cd LO_roms_source_alt
git checkout $LORSACOMMIT
cd $TOPDIR

echo "checking out ROMS source from myroms.org/svn repo"

read -p "Enter your myroms.org username: "
ROMSUSER=$REPLY

svn checkout --username $ROMSUSER https://www.myroms.org/svn/src/trunk@$ROMSVERSION ./LO_roms_source

