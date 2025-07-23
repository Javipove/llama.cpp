#!/bin/bash

#THIS CODE COMPILES LLAMA.CPP

my_array=(20 80 140 200)
my_array_long=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 4096)
my_array_threads=(1 2 4 8 16 32 64)

export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/veloRISK/llama.cpp-dev
export VELORISK_HOME=$LLAMA_HOME/velorisk

export BASE_CC_PATH_CLANG=/scratch/tools/llvm-project/build
export BASE_CC_PATH_CLANG_RUYI=/scratch/tools/ruyisdk-llvm-project/build

export MODEL_HOME=/scratch/tools/models

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/scratch/jpoveda/veloRISK/llama.cpp-dev/velorisk/lib:$LD_LIBRARY_PATH

export CLANG_FLAGS="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"
export CLANG_FLAGS_RUYI="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync_xtheadvector_xtheadzvamo --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

#-j32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 \

echo "Llama.cpp compiled with CLANG 19.0.0 TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
#Our kernel
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH_CLANG/bin/clang \
    CXX=$BASE_CC_PATH_CLANG/bin/clang++ \
    CFLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
    CXXFLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG/lib -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
