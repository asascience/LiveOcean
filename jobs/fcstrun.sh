#!/bin/bash
#set -x
ulimit -s unlimited

if [ $# -ne 2 ] ; then
  echo "Usage: $0 YYYYMMDD COMOUT"
  exit 1
fi

# TODO - make the experiment a parameter

export CDATE=$1
export COMOUT=$2

export HOMElo=$(dirname $PWD)
echo "HOMElo is $HOMElo"

#. /usr/share/Modules/init/bash

module use -a $HOMElo/modulefiles
. $HOMElo/modulefiles/load_modules.sh

#export I_MPI_OFI_LIBRARY_INTERNAL=1

export I_MPI_DEBUG=0
export I_MPI_HYDRA_DEBUG=0
export I_MPI_JOB_STARTUP_TIMEOUT=30
#export I_MPI_HYDRA_IFACE="ens5"

#export I_MPI_FABRICS=shm:ofi
#export FI_PROVIDER=tcp
#export I_MPI_FABRICS=shm
#export I_MPI_FABRICS=verbs
#export FI_PROVIDER=efa
#export FI_PROVIDER=sockets
#export FI_EFA_ENABLE_SHM_TRANSFER=1
#export I_MPI_WAIT_MODE=1   #default is 0
#export I_MPI_HYDRA_ENV=all
#export I_MPI_FABRIC=shm:ofi
#export I_MPI_HYDRA_BOOTSTRAP=ssh

# -iface ens5
# -launcher

HOSTS=${HOSTS:-'localhost'}
export NPROCS=${NPROCS:-16}    # Number of processors
NODES=${NODES:-1}
export PPN=${PPN:-$((NPROCS/NODES))}

MPIOPTS=${MPIOPTS:-"-nolocal -launcher ssh -hosts $HOSTS -np $NPROCS -ppn $PPN"}

EXECDIR=${HOMElo}/LO_roms_user/x4b
EXEC=romsM

YYYY=${CDATE:0:4}
MM=${CDATE:4:2}
DD=${CDATE:6:2}

#export COMOUT=${COMROT}/LO_roms/cas7_t0_x4b/f${YYYY}.${MM}.${DD}
#mkdir -p $COMOUT

#export PTMP=/ptmp/liveocean/f${YYYY}.${MM}.${DD}
#mkdir -p $PTMP

# Don't overwrite if this is setup and launched from the python driver
#if [ ! -s $COMOUT/liveocean.in ] ; then
#  cp -p liveocean.in $COMOUT
#fi

#if [ ! -s $COMOUT/npzd2o_Banas.in ] ; then
#  cp -p npzd2o_Banas.in $COMOUT
#fi

if [ ! -s $COMOUT/bio_Banas.in ] ; then
  cp -p bio_Banas.in $COMOUT
fi

#cp -p ../LO_roms_source_alt/varinfo/varinfo.yaml $COMOUT
#cp -p $HOMElo/LO_roms_source_alt/varinfo/varinfo.yaml $COMOUT

# Copy the Forcing data to /ptmp also
#FRCDIR=/com/liveocean/forcing/f${YYYY}.${MM}.${DD}
#FRCPTMP=/ptmp/liveocean/forcing
#mkdir -p $FRCPTMP
#cp -Rp $FRCDIR $FRCPTMP

# Copy the other ini files
#cp -pf $COMOUT/* $PTMP
#cd $PTMP
cd $COMOUT

# -f specifies the path to the host file listing the cluster nodes; alternatively, you can use the -hosts option to specify a comma-separated list of nodes; if hosts are not specified, the local node is used.
START=`date`
echo "Starting run at: $START"
#export HOSTFILE=$PWD/hosts
#mpirun -np $NPROCS -ppn $PPN -f $HOSTFILE $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
result=0
mpirun $MPIOPTS $EXECDIR/$EXEC liveocean.in > lofcst.log
result=$?

if [ $result -ne 0 ]; then
  echo "ERROR: non-zero return value from mpirun: $result"
fi


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
fi

# This is done in a task, after cluster shutdown
#cp -pf $PTMP/* $COMOUT

TEND=`date`
echo "Run finished at: $TEND with result $result"
exit $result
