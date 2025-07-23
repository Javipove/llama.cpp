

#!/bin/bash
my_array=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 4096)
my_array_vect=(2 4 8 16 32 64)
my_array_big=(64 128 256 512 1024 2048 4096)
my_array_even_bigger=(2048 4096 8192 11008 16384)

#my_array=(64 128 256 512 1024 2048 4096)

export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/veloRISK/llama.cpp-dev
export VELORISK_HOME=$LLAMA_HOME/velorisk

export LD_LIBRARY_PATH=$BASE_CC_PATH/lib:$VELORISK_HOME/lib:$LD_LIBRARY_PATH

export LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib -L$OPENBLAS_PATH/lib -lpthread -lopenblas" 

export PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/"

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
echo "Llama RVV 0.7.1 kernel TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
for value in "${my_array_even_bigger[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4./include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10..0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  USE_VELORISK_QUANTS=1 \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
    veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
done

ur kernel
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
echo "Velorisk kernel 2.0 TRUE ONE TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
# Iterate through the array and execute myprogram.exe
for value in "${my_array_even_bigger[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1  \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
    veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
done
#
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
echo "Llama default kernel TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
for value in "${my_array_even_bigger[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4./include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10..0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1   \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
    veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
done


echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
echo "OpenBLAS sgemm TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log

for value in "${my_array_even_bigger[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
   CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
   CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE" \
   CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE" \
   LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib  -L$OPENBLAS_PATH/lib -lpthread -lopenblas" \
   -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  LLAMA_OPENBLAS=1 \
   PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
   veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
done

#echo "------------------------------------------- TITLE">> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#echo "Velorisk fp32fp32 kernel TITLE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#
#for value in "${my_array_big[@]}"; do
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#make clean
#make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
#    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PdATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib -L$OPENBLAS_PATH/lib -lpthread -lopenblas" \
#    -j32 LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1  \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
#    veloriskmmul benchmark-matmult
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
#done
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
echo "OpenBLAS SGEMV TITLE" >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
for value in "${my_array_even_bigger[@]}"; do
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4./include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE -DOPENBLAS_GEMV" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10..0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=$value -DGGML_USE_BLAS_NO_CHECK_SIZE -DOPENBLAS_GEMV" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib  -L$OPENBLAS_PATH/lib -lpthread -lopenblas" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  LLAMA_OPENBLAS=1 \
    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
    veloriskmmul benchmark-matmult
#./veloriskmmul
#numactl -C 1 -m 0 -- ./benchmark-matmult
./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_matvec_cleanup_paper.log
#./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_custom_kernel_TEST_matvec_2.log
done
