#!/bin/bash

my_array=(20 80 140 200)
my_array_long=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 4096)
my_array_threads=(1 2 4 8 16 32 64)
my_array_small_threads=(1 2 4 8 16 32)
my_array_big_vectmat=(64 128 256 512 1024 2048 4096)

export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/veloRISK/llama.cpp-dev
export VELORISK_HOME=$LLAMA_HOME/velorisk

export MODEL_HOME=/scratch/tools/models

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH

export LD_LIBRARY_PATH=/scratch/jpoveda/veloRISK/llama.cpp-dev/velorisk/lib:$LD_LIBRARY_PATH


#-j32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 \

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1


#Our kernel

#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi.log
#echo "Velorisk kernel complex TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi.log
## Iterate through the array and execute myprogram.exe
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#make clean
#make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
#    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
#
#for value in "${my_array_threads[@]}"; do
#
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n 20  -p 'Once upon a time, there was a kingdom' -t $value --log-enable >> $VELORISK_HOME/tests/llama/results_inference_multi.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference_multi.log
#
#done

##Our kernel
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
#echo "Velorisk kernel simple TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
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
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
##./benchmark-matmult >> $VELORISK_HOME/tests/llama/results_custom_kernel_testing_error_ours.log
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
#done

#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
#echo "Lllama RVV 0.7.1 kernel TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
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
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  USE_VELORISK_QUANTS=1 \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
#done#
#

#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
#echo "Llama default kernel TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
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
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=1" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1   \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
#done



#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
#echo "OpenBLAS sgemm TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
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
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=1 -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=1 -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib  -L$OPENBLAS_PATH/lib -lpthread -lopenblas" \
#    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1  LLAMA_OPENBLAS=1 \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
#done
#
#echo "------------------------------------------- TITLE">> $VELORISK_HOME/tests/llama/results_inference.log
#echo "Velorisk fp32fp32 kernel TITLE" >> $VELORISK_HOME/tests/llama/results_inference.log
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
#    CFLAGS="-mcpu=c920 -I$BASE_CC_PdATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=1 -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -I$OPENBLAS_PATH/include -DVARIABLE_VALUE=1 -DGGML_USE_BLAS_NO_CHECK_SIZE" \
#    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib -L$OPENBLAS_PATH/lib -lpthread -lopenblas" \
#    -j32 LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1  \
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
##./veloriskmmul
##numactl -C 1 -m 0 -- ./benchmark-matmult
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
##./benchmark-matmult | grep "STORAGE" >> $VELORISK_HOME/tests/llama/results_inference.log
#done


### TEST FOR PAPER #########
#Our kernel

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/summary_results_test_matvec_2.log
echo "Velorisk kernel complex, variable mat_vec kernel  " >> $VELORISK_HOME/tests/llama/summary_results_test_matvec_2.log
# Iterate through the array and execute myprogram.exe
cd $VELORISK_HOME
pwd
make clean
make all VELORISK_USE_API=$1
for value in "${my_array_big_vectmat[@]}"; do
cd $LLAMA_HOME
pwd
make clean
make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
    CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
    CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
    CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include -DVARIABLE_VALUE=$value -DVELORISK_COMPLEX" \
    LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
    -j32 LLAMA_OPENMP=OFF LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
    benchmark-matmult
#    PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
#
#./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n $value  -p 'Once upon a time, there was a kingdom' -t 1 --log-enable >> $VELORISK_HOME/tests/llama/results_inference.log
#grep -w -E "Cmd:|system_info:|llama_print_timings:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference.log
./benchmark-matmult  | grep "STORAGE" >> $VELORISK_HOME/tests/llama/summary_results_test_matvec_2.log

done
