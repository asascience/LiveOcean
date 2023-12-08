
module purge

TARGETMX=${TARGETMX:-x86_64}

if [[ $TARGETMX == "skylake_avx512" ]]; then

  # don't set NO_AVX512 - make uses ifdef - default is to use
  module load gcc-8.5.0-gcc-4.8.5-iakdnjp
  module load intel-oneapi-compilers-2021.3.0-gcc-8.5.0-gp3iweu
  module load intel-oneapi-mpi-2021.3.0-intel-2021.3.0-bixgqcx
  module load zlib-1.2.11-intel-2021.3.0-gcfkvht
  module load libszip-2.1.1-intel-2021.3.0-pzpdymm
  module load netcdf-c-4.8.0-intel-2021.3.0-pejnxdb
  module load netcdf-fortran-4.5.4-intel-2021.3.0-4lyzqsf
  module load hdf5-1.10.7-intel-2021.3.0-btc4zhc

elif [[ $TARGETMX == "haswell" ]]; then
  export NO_AVX512=on
  module avail
  echo "target haswell not supported yet"
  exit
elif [[ $TARGETMX == "x86_64" ]]; then
  # Use the x86_64 build targets
  export NO_AVX512=on
  module use -a /mnt/efs/fs1/save/environments/spack/share/spack/modules/linux-rhel8-x86_64
  module load intel-oneapi-compilers/2023.1.0-gcc-11.2.1-jbyreen
  module load intel-oneapi-mpi/2021.9.0-intel-2021.9.0-egjrbfg
  module load zlib-ng/2.1.4-intel-2021.9.0-57ptxrw
  module load libszip/2.1.1-intel-2021.9.0-s3p3pgl
  module load hdf5/1.14.3-intel-2021.9.0-4xskthb
  module load netcdf-fortran/4.6.1-intel-2021.9.0-7mcdcga
  module load netcdf-c/4.9.2-intel-2021.9.0-o6vd5lb

  ## HACK HERE WITH SPACK - use 'module show <netcdf module above>' to get the full path
  NETCDF="/mnt/efs/fs1/save/environments/spack/opt/spack/linux-rhel8-x86_64/intel-2021.9.0/netcdf-fortran-4.6.1-7mcdcgapb2ka6xqkv23tnwtywysrchxi"

  NETCDFC="/mnt/efs/fs1/save/environments/spack/opt/spack/linux-rhel8-x86_64/intel-2021.9.0/netcdf-c-4.9.2-o6vd5lbsibdn7yjacyvy7crtxacdibye"

  export LD_LIBRARY_PATH="$NETCDF/lib:$LD_LIBRARY_PATH"
  export LD_LIBRARY_PATH="$NETCDFC/lib:$LD_LIBRARY_PATH"

  export NETCDF_INCDIR="$NETCDF/include"
else
  echo "Target platform not supported"
  exit
fi
