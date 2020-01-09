#!/bin/bash
set -xa

#module purge
module load gcc/6.5.0
module load mpi/intel
module load netcdf

export I_MPI_FABRICS=shm:ofi
#export I_MPI_FABRICS=shm
#export I_MPI_FABRICS=efa
#export I_MPI_FABRICS=verbs

export FI_PROVIDER=efa
#export FI_PROVIDER=sockets
#export FI_PROVIDER=tcp
#export FI_EFA_ENABLE_SHM_TRANSFER=1
#export I_MPI_WAIT_MODE=1   #default is 0

export NODES=1
export NPP=36
export NPP=${NPP:-16}    # Number of processors

export PPN=$((NPP/NODES))

export HOSTFILE=$PWD/hosts2
export EXECDIR=/save/LiveOcean/exec

#shm:tcp
#shm:ofi

# Broken: Does notuse TMPDIR, writes directly to COMOUT
# COMOUT hardcoded in liveocean.in
#TMPDIR=/ptmp/lo.20191106
#mkdir -p $TMPDIR

export COMOUT=/com/liveocean/f2019.11.06.run2
mkdir -p $COMOUT

cp -p liveocean2.in $COMOUT
cp -p npzd2o_Banas.in $COMOUT

cd $COMOUT

# -f specifies the path to the host file listing the cluster nodes; alternatively, you can use the -hosts option to specify a comma-separated list of nodes; if hosts are not specified, the local node is used.

#hostfile=/save/LiveOcean/jobs/hosts.local
export I_MPI_DEBUG=1 

#export I_MPI_HYDRA_ENV=all
#export I_MPI_FABRIC=shm:ofi
#shm:ofi
#export I_MPI_HYDRA_BOOTSTRAP=ssh

# -iface ens5
# -launcher

START=`date`
echo "Starting run at: $START"
# THESE RUN!
# mpirun -np $NPP -f $hostfile -iface ens5 $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
#mpirun -bind-to numa:4 -map-by core:72 -f $hostfile -iface ens5 $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
mpirun -np $NPP -ppn $PPN -f $HOSTFILE $EXECDIR/oceanM.lo6biom liveocean2.in > lofcst.log

TEND=`date`
echo "Run finished at: $TEND"


#mpirun -bind-to numa:4 -map-by core:72 -iface ens5 -f $hostfile $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
#mpirun -np $NPP -iface ens5 $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
#mpirun -np $NPP -f $hostfile $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
#mpirun -np $NPP $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log
#mpirun -np $NPP $EXECDIR/oceanM.lo6biom liveocean.in > lofcst.log

