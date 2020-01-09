#!/bin/bash

modconf=lo6biom
TOPDIR=$PWD

makedir=$TOPDIR/LiveOcean_roms/makefiles/$modconf
makefile=$makedir/makefile

ROMSDIR=$TOPDIR/LiveOcean_roms/LO_ROMS
EXECDIR=$TOPDIR/LiveOcean_roms/exec
mkdir -p $EXECDIR

export COMP_F=gfortran
export COMP_F_MPI90=mpif90
export COMP_F_MPI=mpifc
export COMP_ICC=gcc
export COMP_CC=gcc
export COMP_CPP=cpp
export COMP_MPCC=mpigcc

module purge
module load gcc/6.5.0
#module load mpi/intel/2019.5.281
module load mpi/intel/2020.0.154
# module load netcdf/4.2
module load netcdf/4.5

export NETCDF_INCDIR="$NETCDF/include"
export NETCDF_LIBDIR="$NETCDF/lib"
export NETCDF_LDFLAGS="-L$NETCDF_LIBDIR -lnetcdff -lnetcdf"

cd $ROMSDIR
#gmake clean
gmake -f $makefile
mv $makedir/oceanM $EXECDIR/oceanM.$modconf
