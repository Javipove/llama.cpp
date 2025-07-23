#!/bin/bash
#my_array=(64 128 256 512 1024 2048 4096)
my_array=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 4096)

export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/veloRISK/llama.cpp-dev
export VELORISK_HOME=$LLAMA_HOME/velorisk

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH

#-j32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 \

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
##Our kernel
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#echo "Velorisk kernel complex TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#
## Iterate through the array and execute myprogram.exe
#for value in "${my_array[@]}"; do
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#make clean
#make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
#    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1  \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
#    veloriskmmul benchmark-matmult
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#done
#
##Our kernel
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#echo "Velorisk kernel simple TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#
## Iterate through the array and execute myprogram.exe
#for value in "${my_array[@]}"; do
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#make clean
#make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
#    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value " \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value " \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1  \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
#    veloriskmmul benchmark-matmult
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#done

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_2_cleanup.log
echo "Lllama RVV 0.7.1 kernel TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_2_cleanup.log
for value in "${my_array[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  USE_VELORISK_QUANTS=1 \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
    veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_2_cleanup.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
done