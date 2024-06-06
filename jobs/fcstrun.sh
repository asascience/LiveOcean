#!/bin/bash
ulimit -s unlimited

if [ $# -ne 2 ] ; then
  echo "Usage: $0 YYYYMMDD COMOUT"
  exit 1
fi

. /usr/share/Modules/init/bash
. ../modulefiles/load_modules.sh

#set -x

export CDATE=$1
export COMOUT=$2

echo "DEBUG2: in $0"
echo "COMOUT: $COMOUT"

#export I_MPI_OFI_LIBRARY_INTERNAL=1
export I_MPI_DEBUG=0
export I_MPI_HYDRA_DEBUG=0
export I_MPI_JOB_STARTUP_TIMEOUT=30
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

result=0
echo "Calling mpirun ....from $0"
mpirun $MPIOPTS $EXECDIR/$EXEC liveocean.in > lofcst.log

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

# This is done in a task, after cluster shutdown
#cp -pf $PTMP/* $COMOUT

TEND=`date`
echo "Run finished at: $TEND with result $result"
exit $result
