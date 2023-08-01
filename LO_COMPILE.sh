#!/bin/bash
#set -x

TOPDIR=$PWD

BUILDDIR="${TOPDIR}/LO_roms_user/x2b"
BUILDSCRIPT=build_roms.sh
BUILDOPTS='-j 2'

export MY_ROOT_DIR=/save/ioos/patrick.tripp/LiveOcean

#    -j [N]      Compile in parallel using N CPUs                       :::
#                  omit argument for all available CPUs                 :::
#                                                                       :::
#    -p macro    Prints any Makefile macro value. For example,          :::
#                                                                       :::
#                  build_roms.sh -p FFLAGS                              :::
#                                                                       :::
#    -noclean    Do not clean already compiled objects 

export COMP_F=ifort
export COMP_F_MPI90=mpif90
export COMP_F_MPI=mpif90
export COMP_ICC=icc
export COMP_CC=icc
export COMP_CPP=cpp
export COMP_MPCC='mpicc -fc=icc'

TARGET=${TARGET:-'skylake_avx512'}

module purge

if [[ $TARGET == "skylake_avx512" ]]; then
  module load gcc-8.5.0-gcc-4.8.5-iakdnjp
  module load intel-oneapi-compilers-2021.3.0-gcc-8.5.0-gp3iweu
  module load intel-oneapi-mpi-2021.3.0-intel-2021.3.0-bixgqcx
  module load zlib-1.2.11-intel-2021.3.0-gcfkvht
  module load libszip-2.1.1-intel-2021.3.0-pzpdymm
  module load netcdf-c-4.8.0-intel-2021.3.0-pejnxdb
  module load netcdf-fortran-4.5.4-intel-2021.3.0-4lyzqsf
  module load hdf5-1.10.7-intel-2021.3.0-btc4zhc

  # Tells build system which compiler options to use
  export FORT=ifort

elif [[ $TARGET == "x86_64" ]]; then
  export FORT=ifort-x86_64
fi

NETCDF=`nf-config --prefix`
export NETCDF_INCDIR=`nf-config --includedir`
export NETCDF_LIBDIR="${NETCDF}/lib"
cd $BUILDDIR
./$BUILDSCRIPT $BUILDOPTS

