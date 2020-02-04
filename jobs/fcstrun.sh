#!/bin/bash
set -x
ulimit -s unlimited

if [ $# -ne 1 ] ; then
  echo "Usage: $0 YYYYMMDD"
  exit 1
fi

export CDATE=$1

module purge
export I_MPI_OFI_LIBRARY_INTERNAL=1
module load gcc/6.5.0
module load mpi/intel
module load netcdf
module load hdf5

export I_MPI_DEBUG=1 
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
#shm:ofi
#export I_MPI_HYDRA_BOOTSTRAP=ssh

# -iface ens5
# -launcher

export HOMEnos=$(dirname $PWD)
echo "HOMEnos is $HOMEnos"

HOSTS=${HOSTS:-'localhost'}
export NPROCS=${NPROCS:-16}    # Number of processors
NODES=${NODES:-1}
export PPN=${PPN:-$((NPROCS/NODES))}

MPIOPTS=${MPIOPTS:-"-nolocal -launcher ssh -hosts $HOSTS -np $NPROCS -ppn $PPN"}

EXECDIR=${HOMEnos}/LiveOcean_roms/exec
EXEC=oceanM.lo6biom

YYYY=${CDATE:0:4}
MM=${CDATE:4:2}
DD=${CDATE:6:2}

export COMOUT=/com/liveocean/f${YYYY}.${MM}.${DD}
mkdir -p $COMOUT

# Don't overwrite if this is setup and launched from the python driver
if [ ! -s $COMOUT/liveocean.in ] ; then
  cp -p liveocean.in $COMOUT
fi
cp -p npzd2o_Banas.in $COMOUT

cd $COMOUT

# -f specifies the path to the host file listing the cluster nodes; alternatively, you can use the -hosts option to specify a comma-separated list of nodes; if hosts are not specified, the local node is used.
START=`date`
echo "Starting run at: $START"
#export HOSTFILE=$PWD/hosts
#mpirun -np $NPROCS -ppn $PPN -f $HOSTFILE $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
result=0
mpirun $MPIOPTS $EXECDIR/$EXEC liveocean.in > lofcst.log

error=`grep ERROR lofcst.log`
if [ $error -eq 0 ] ; then
  result=`grep exit_flag lofcst.log | awk -F: '{print $2}'`
fi

TEND=`date`
echo "Run finished at: $TEND with result $result"
exit $result
