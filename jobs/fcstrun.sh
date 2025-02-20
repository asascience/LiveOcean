#!/bin/bash

set -x

ulimit -s unlimited

if [ $# -ne 2 ] ; then
  echo "Usage: $0 YYYYMMDD COMOUT"
  exit 1
fi

. /usr/share/Modules/init/bash
. ../modulefiles/load_modules.sh

#module load libfabric-aws/1.22.0amzn4.0

# set -x
export CDATE=$1
export COMOUT=$2

echo "COMOUT: $COMOUT"

# I_MPI_OFI_LIBRARY_INTERNAL=<arg>
# <arg>	Binary indicator
# enable | yes | on | 1	Use libfabric from the Intel MPI Library
# disable | no | off | 0	Do not use libfabric from the Intel MPI Library

# I_MPI_OFI_PROVIDER_DUMP=<arg>
# <arg>	Binary indicator
# enable | yes | on | 1	Print the list of all OFI providers and their attributes from an OFI library
# disable | no | off | 0	No action. This is the default value

# I_MPI_OFI_PROVIDER=<name>
# <name>	The name of the OFI provider to load

# I_MPI_OFI_TAG_DYNAMIC=<arg>
# <arg>	Binary indicator
# enable | yes | on | 1	Enable automatic OFI tag partitioning
# disable | no | off | 0	Use static OFI tag layout. This is the default value

# I_MPI_FABRICS=ofi | shm:ofi | shm
# <fabric>	Define a network fabric.
# shm	Shared memory transport (used for intra-node communication only).
# ofi	OpenFabrics Interfaces* (OFI)-capable network fabrics, such as Intel® Omni-Path Architecture, InfiniBand*, and Ethernet (through OFI API).
# default is shm:ofi

# I_MPI_DEBUG=<level>[,<flags>]
# Argument	Description
# <level>	Indicate the level of debug information provided.
# 0	Output no debugging information. This is the default value.
# 1	Output libfabric* version and provider.
# 2	Output information about the tuning file used.
# 3	Output effective MPI rank, pid and node mapping table.
# 4	Output process pinning information.
# 5	Output environment variables specific to the Intel® MPI Library.
# > 5	Add extra levels of debug information.

export I_MPI_OFI_LIBRARY_INTERNAL=1
export I_MPI_OFI_PROVIDER_DUMP=1 # not supported in currently installed impi version
export I_MPI_OFI_PROVIDER=efa
export I_MPI_FABRICS=ofi
export I_MPI_DEBUG=1


# I_MPI_PMI=<version>
# Argument	Description
# auto | pmi1 | pmi2 | pmix	Specify the PMI version. The default value is auto

# Example from online Documents:
# To launch an application using Intel MPI and PMIx, you can use Cray's PALS*.
# For that, you need the following environment variables:
# I_MPI_OFI_LIBRARY=<path-to-crays>/libfabric.so.1
# I_MPI_OFI_PROVIDER=cxi
# I_MPI_PMI_LIBRARY=<path-to>/libpmix.so
# I_MPI_PMI=pmix

#export I_MPI_HYDRA_DEBUG=0
#export I_MPI_JOB_STARTUP_TIMEOUT=30
#export FI_PROVIDER=efa
#export I_MPI_WAIT_MODE=1   #default is 0

export HOMEnos=$(dirname $PWD)
echo "HOMEnos is $HOMEnos"

HOSTS=${HOSTS:-'localhost'}
export NPROCS=${NPROCS:-16}    # Number of processors

NODES=${NODES:-1}
export PPN=${PPN:-$((NPROCS/NODES))}

MPIOPTS=${MPIOPTS:-"-nolocal -launcher ssh -hosts $HOSTS -np $NPROCS -ppn $PPN"}

EXECDIR=${HOMEnos}/LO_roms_user/x4b
EXEC=romsM

YYYY=${CDATE:0:4}
MM=${CDATE:4:2}
DD=${CDATE:6:2}

echo "COMOUT: $COMOUT"
mkdir -p $COMOUT

if [ ! -s $COMOUT/bio_Banas.in ] ; then
  cp -p bio_Banas.in $COMOUT
fi

# For /ptmp when using FSx Lustre
#export PTMP=/ptmp/liveocean/f${YYYY}.${MM}.${DD}
#mkdir -p $PTMP
# Copy the Forcing data to /ptmp also
#FRCDIR=/com/liveocean/forcing/f${YYYY}.${MM}.${DD}
#FRCPTMP=/ptmp/liveocean/forcing
#mkdir -p $FRCPTMP
#cp -Rp $FRCDIR $FRCPTMP
# Copy the other ini files
#cp -pf $COMOUT/* $PTMP
#cd $PTMP

cd $COMOUT

START=`date`
echo "Starting run at: $START"

mpiresult=0
echo "Calling mpirun ....from $0"
mpirun $MPIOPTS $EXECDIR/$EXEC liveocean.in > lofcst.log
mpiresult=$?

# ROMS/TOMS: DONE
# Check for success message
grep "ROMS/TOMS: DONE" lofcst.log
retval=$?

if [ $retval -ne 0 ] ; then  # No success message, return exit flag if it exists
  result=1   # model did not complete
  grep exit_flag lofcst.log
  retval=$?
  if [ $retval -eq 0 ] ; then # get the exit code from roms
    result=`grep exit_flag lofcst.log | awk -F: '{print $2}'`
  fi
else
  result=0
fi

if [ $mpiresult -ne 0 ]; then
  result=$mpiresult
fi

TEND=`date`
echo "Run finished at: $TEND with result $result"

exit $result
