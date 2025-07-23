export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
#export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export OPENBLAS_PATH=/scratch/jpoveda/OpenBLAS_910V_Default_V0326_Cross
export LLAMA_HOME=/scratch/jpoveda/veloRISK/llama.cpp-dev
export VELORISK_HOME=$LLAMA_HOME/velorisk

export BASE_CC_PATH_CLANG=/scratch/tools/llvm-project/build
export BASE_CC_PATH_CLANG_RUYI=/scratch/tools/ruyisdk-llvm-project/build
export BASE_CC_PATH_GCC_14=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build

export MODEL_HOME=/scratch/tools/models

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/scratch/jpoveda/veloRISK/llama.cpp-dev/velorisk/lib:$LD_LIBRARY_PATH

export CLANG_FLAGS="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"
export CLANG_FLAGS_RUYI="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync_xtheadvector_xtheadzvamo --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"

export PREFIX_14="/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/"
export CX_FLAGS_GCC_14="-L$PREFIX_14/lib -L$PREFIX_14/lib64 -I$PREFIX_14/include -Wl,--rpath=$PREFIX_14/lib -Wl,--rpath=$PREFIX_14/lib64"


export GCC_14_OPT="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadfmv_xtheadint_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync_xtheadvector -mtune=generic-ooo"

cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH_CLANG/bin/clang \
    CXX=$BASE_CC_PATH_CLANG/bin/clang++ \
    CFLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DGGML_USE_QVELORISK -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX " \
    CXXFLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DGGML_USE_QVELORISK -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX " \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG/ib -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 LLAMA_NO_CCACHE=1 \

