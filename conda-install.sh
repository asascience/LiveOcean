#!/usr/bin/env bash

# Download installer
BASEDIR=/save/ec2-user
cd $BASEDIR
mkdir -p miniconda3
cd miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ./miniconda.sh
bash ./miniconda.sh -b -u -p .
# rm -rf ./miniconda.sh

#Add the path to ~/.bashrc
# Set path in ~/.bashrc
#export PATH="/save/ec2-user/miniconda3/bin:$PATH"

# source "/save/ec2-user/miniconda3/etc/profile.d/conda.csh"
# . "/save/ec2-user/miniconda3/etc/profile.d/conda.sh"

# This will conflict with Cloudflow
# ./miniconda3/bin/conda init bash
# ./miniconda3/bin/conda init tcsh

cd $BASEDIR/LiveOcean

# Activate the base conda env
. ./conda-init.sh       # BASH
# source ./conda-init.csh # TCSH 

conda update conda

cd LiveOcean/LO
git pull

#Sometimes the remote machines will complain about this. One solution is to issue this command while inside the repo on the remote machine:
# git config pull.ff only'

# Create the (loenv) environment
conda env create -f loenv.yml >& env.log &

conda activate loenv

conda update -n base -c defaults conda

conda env update -f loenv.yml

#   131	13:56	conda info --envs
#   132	13:57	conda activate base
#   133	13:57	conda activate loenv

cd $BASEDIR/LiveOcean

python ../LO/test_loenv.py

# https://github.com/parkermac/LO?tab=readme-ov-file#creating-your-own-environment-highly-recommended
# Creating your own environment! Highly recommended
# One way to do this would be to:

# create a directory LO_user at the same level as LO
# copy loenv.yml to LO_user or any other repo that is yours
# rename it, for example, to myenv.yml
# edit it so that name: myenv is the first line
# add or subtract any packages you like
# if you are using the lo_tools local package, change the path for it in the yml to be -e ../LO/lo_tools lo_tools (assuming that is the correct relative path)
# then do: conda env create -f myenv.yml > env.log & and there you are!
# At any time you can do conda info --envs to find out what environments you have. And if you want to cleanly get rid of an environment, just make sure it is not active, then do conda env remove -n myenv or whatever name you are wanting to remove. This will not delete your yml file.
# 

# To activate this environment, use
#
#     $ conda activate loenv
#
# To deactivate an active environment, use
#
#     $ conda deactivate

#source ./conda-init.csh
#conda activate loenv
# (loenv) [ec2-user@ip-10-0-0-156 LiveOcean]$

