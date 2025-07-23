export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
#export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export OPENBLAS_PATH=/scratch/jpoveda/OpenBLAS_910V_Default_V0326_Cross
export LLAMA_HOME=/scratch/jpoveda/llama_rebase/llama.cpp

export VELORISK_HOME=$LLAMA_HOME/velorisk

export BASE_CC_PATH_CLANG=/scratch/tools/llvm-project/build
export BASE_CC_PATH_CLANG_RUYI=/scratch/tools/ruyisdk-llvm-project/build
export BASE_CC_PATH_GCC_14=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build

export MODEL_HOME=/scratch/tools/models

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/scratch/jpoveda/llama_rebase/llama.cpp/velorisk/lib:$LD_LIBRARY_PATH

export CLANG_FLAGS="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"
export CLANG_FLAGS_RUYI="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync_xtheadvector_xtheadzvamo --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"

export PREFIX_14="/scratch/tools/compilers/riscv_gnu/riscv-gnu-build"
export CXX_FLAGS_GCC_14="-L$PREFIX_14/lib -L$PREFIX_14/lib64 -I$PREFIX_14/include -Wl,--rpath=$PREFIX_14/lib -Wl,--rpath=$PREFIX_14/lib64"


export GCC_14_OPT="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadfmv_xtheadint_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync_xtheadvector -mtune=generic-ooo"

cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
#pwd
#cmake --build build --target clean
##make CFLAGS="-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
##    CXXFLAGS="-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
##    LDFLAGS="-lvelorisk -L$VELORISK_HOME/lib" \
##    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
##    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##-j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
##make CC=$BASE_CC_PATH_CLANG_RUYI/bin/clang \
##    CXX=$BASE_CC_PATH_CLANG_RUYI/bin/clang++ \
##    CFLAGS="$CLANG_FLAGS_RUYI -I$BASE_CC_PATH_CLANG_RUYI/include -I$BASE_CC_PATH_CLANG_RUYI/projects/openmp/runtime/src  -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
##    CXXFLAGS="$CLANG_FLAGS_RUYI -I$BASE_CC_PATH_CLANG_RUYI/include -I$BASE_CC_PATH_CLANG_RUYI/projects/openmp/runtime/src  -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
##    LDFLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG_RUYI/lib -L$VELORISK_HOME/lib" \
##    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
##    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##
##cmake -B build --fresh -DCMAKE_C_COMPILER=$BASE_CC_PATH_CLANG/bin/clang \
##    -DCMAKE_CXX_COMPILER=$BASE_CC_PATH_CLANG/bin/clang++ \
##    -DCMAKE_C_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
##    -DCMAKE_CXX_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
##    -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG/lib -L$VELORISK_HOME/lib" \
##    -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF \
##
##cmake --build build --config Release -j 32
#
##cmake -B build --fresh -DCMAKE_C_COMPILER=gcc \
##   -DCMAKE_CXX_COMPILER=g++ \
##   -DGGML_OPENMP=OFF -DGGML_CCACHE=OFF -DGGML_RVV=OFF \
##
##cmake --build build --config Release -j 32
#
#
#
################ XUANTIE GCC COMPILATION ###########################
export LLAMA_MAKEFILE=1
export GGML_NO_CCACHE=1
export LLAMA_NO_CCACHE=1
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib -L$(pwd)/build/bin " \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_CCACHE=1 GGML_NO_CCACHE=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 GGML_NO_AMX=1 GGML_NO_CPU_AARCH64=1 GGML_RVV=OFF LLAMA_MAKEFILE=1 llama-cli \

#
#
################ GCC 14 COMPILATION ###########################
#export LD_LIBRARY_PATH=$PREFIX_14/lib64:$PREFIX_14/lib:$PREFIX_14/sysroot:$LD_LIBRARY_PATH
#export LDFLAGS="-lvelorisk --sysroot=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot -L$PREFIX_14/lib -L$PREFIX_14/#lib64 -L$VELORISK_HOME/lib" 
#
#cmake --build build --target clean
#
#cmake -B build --fresh -DCMAKE_C_COMPILER=$BASE_CC_PATH_GCC_14/bin/riscv64-unknown-linux-gnu-gcc \
#    -DCMAKE_CXX_COMPILER=$BASE_CC_PATH_GCC_14/bin/riscv64-unknown-linux-gnu-g++ \
#    -DCMAKE_LINKER=$BASE_CC_PATH_GCC_14/bin/riscv64-unknown-linux-gnu-g++ \
#   -DCMAKE_C_FLAGS="$GCC_14_OPT --sysroot=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot -I$PREFIX_14/include -fpermissive -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#   -DCMAKE_CXX_FLAGS="$GCC_14_OPT --sysroot=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot -I$PREFIX_14/include -fpermissive -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#   -DCMAKE_SOURCE_DIR="$PREFIX_14/sysroot/lib" \
#   -DCMAKE_SYSROOT="/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot" \
#   -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$PREFIX_14/lib -L$PREFIX_14/lib64 -L$VELORISK_HOME/lib -L/scratch/tools/compilers/xuantie_gcc/sysroot/lib " \
#   -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF 

#cmake --build build --config Release -j 32 
#make clean
#make CC=$BASE_CC_PATH_GCC_14/bin/riscv64-unknown-linux-gnu-gcc \
#    CXX=$BASE_CC_PATH_GCC_14/bin/riscv64-unknown-linux-gnu-g++ \
#    CFLAGS="$GCC_14_OPT --sysroot=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot -I$PREFIX_14/include -fpermissive -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#    CXXFLAGS="$GCC_14_OPT --sysroot=/scratch/tools/compilers/riscv_gnu/riscv-gnu-build/sysroot -I$PREFIX_14/include -fpermissive -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#    LDFLAGS="-lvelorisk -L$PREFIX_14/lib -L$PREFIX_14/lib64 -L$PREFIX_14/sysroot/lib -L$VELORISK_HOME/lib -L$(pwd)/build/bin " \
 #   -j32 LLAMA_OPENMP=OFF LLAMA_NO_CCACHE=1 GGML_NO_CCACHE=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 GGML_NO_AMX=1 GGML_NO_CPU_AARCH64=1 GGML_RVV=OFF LLAMA_MAKEFILE=1 llama-cli \


#make CC=$BASE_CC_PATH_GCC_14/bin/gcc \
#    CXX=$BASE_CC_PATH_GCC_14/bin/g++ \
#    CFLAGS="$GCC_14_OPT --sysroot=/scratch/#tools/compilers/riscv_gnu/riscv-gnu-build/#sysroot -I$PREFIX_14/include -fpermissive #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX " \
#    CXXFLAGS="$GCC_14_OPT --sysroot=/scratch/#tools/compilers/riscv_gnu/riscv-gnu-build/#sysroot -I$PREFIX_14/include -fpermissive #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX " \
#    LDFLAGS="-lvelorisk --sysroot=/scratch/#tools/compilers/riscv_gnu/riscv-gnu-build/#sysroot -L$PREFIX_14/lib -L$PREFIX_14/#lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 #USE_VELORISK=1 LLAMA_NO_CCACHE=1 \

#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \

##make -j32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 PKG_CONFIG_PATH=$OPENBLAS_PATH/lib/pkgconfig LD_LIBRARY_PATH=$OPENBLAS_PATH/lib CMAKE_PREFIX_PATH=$OPENBLAS_PATH
##remenber this -DQUANTIZATION_Q8_VELORISK exists for the CFLAFS and CXXFLAGS
