#!/bin/bash

#grep 'prompt eval time' ./results_inference_multicomp_paper.log | sed 's/.* \([0-9]*\.[0-9]*\) tokens per second.*/\1/' &> ./numbers_multicomp.log
#grep '       eval time' ./results_inference_multicomp_paper.log | sed 's/.* \([0-9]*\.[0-9]*\) tokens per second.*/\1/' &> ./numbers_multicomp.log
my_array=(20 80 140 200)
my_array_long=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 4096)
my_array_threads_small=(1 2 4)
my_array_threads_big=(8 16 32 64)

export BASE_CC_PATH=/scratch/tools/compilers/xuantie_gcc
export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/llama_rebase/llama.cpp
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

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
#Our kernel


## BE SURE THE SYSTEM SET UP IS THE CORRECT ONE ###
sync
sudo echo 3 > /proc/sys/vm/drop_caches
sudo echo 1 > /proc/sys/kernel/numa_balancing

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "-------------BEGINNING OF TESTING---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "Velorisk kernel complex GCC Xuantie TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
# Iterate through the array and execute myprogram.exe
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
cd $LLAMA_HOME
pwd
#export LD_LIBRARY_PATH="/scratch/tools/compilers/xuantie_gcc/sysroot/lib:$BASE_CC_PATH/lib:$BASE_CC_PATH/lib64:/usr/lib64:/usr/lib:$LD_LIBRARY_PATH"
#cmake --build build --target clean
#cmake -B build --fresh -DCMAKE_C_COMPILER=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
#    -DCMAKE_CXX_COMPILER=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
#    -DCMAKE_C_FLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L/usr/lib64" \
#    -DCMAKE_C_LINK_FLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L/usr/lib64" \
#    -DCMAKE_CXX_FLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L/usr/lib64" \
#    -DCMAKE_CXX_LINK_FLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed #-I$VELORISK_HOME/include -DVARIABLE_VALUE=1 -DVELORISK_COMPLEX -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L/usr/lib64" \
#    -DCMAKE_FIND_ROOT_PATH="$BASE_CC_PATH/lib" \
#    -DCMAKE_SOURCE_DIR="$BASE_CC_PATH/lib" \
#    -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib -L/scratch/tools/compilers/xuantie_gcc/sysroot/lib -L/usr/lib64 " \
#    -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF \
#
#cmake --build build --config Release -j 32 


for value in "${my_array_threads_small[@]}"; do
echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
./llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
echo "./llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
sync
sudo echo 3 > /proc/sys/vm/drop_caches
done

#for value in "${my_array_threads_big[@]}"; do
#echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#echo "./llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#./llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#sync
#sudo echo 3 > /proc/sys/vm/drop_caches
#done
##
#unset LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH
##
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "Velorisk kernel complex GCC 13 TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
### Iterate through the array and execute myprogram.exe
###cd $VELORISK_HOME
###pwd
###make clean
###make all VELORISK_USE_API=$1
##cd $LLAMA_HOME
##pwd
##cmake --build build --target clean
##cmake -B build --fresh -DCMAKE_C_COMPILER=gcc \
##    -DCMAKE_CXX_COMPILER=g++ \
##    -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$VELORISK_HOME/lib" \
##    -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF \
##
##cmake --build build --config Release -j 32 
##
##./build/bin/llama-cli --version >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##
##for value in "${my_array_threads_small[@]}"; do
##echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is #so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so #cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
##grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.#log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##sync
##sudo echo 3 > /proc/sys/vm/drop_caches
##done
##
##for value in "${my_array_threads_big[@]}"; do
##echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it #is so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so #cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
##grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.#log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##sync
##sudo echo 3 > /proc/sys/vm/drop_caches
##done
#
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#echo "Velorisk kernel complex CLANG TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
## Iterate through the array and execute myprogram.exe
##cd $VELORISK_HOME
##pwd
##make clean
##make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#cmake --build build --target clean
#cmake -B build --fresh -DCMAKE_C_COMPILER=$BASE_CC_PATH_CLANG/bin/clang \
#    -DCMAKE_CXX_COMPILER=$BASE_CC_PATH_CLANG/bin/clang++ \
#    -DCMAKE_C_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
#    -DCMAKE_CXX_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
#    -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG/lib -L$VELORISK_HOME/lib" \
#    -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF \
#
#cmake --build build --config Release -j 32 
#./build/bin/llama-cli --version >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#
#
##for value in "${my_array_threads_small[@]}"; do
##echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is #so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so #cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
##grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.#log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##sync
##sudo echo 3 > /proc/sys/vm/drop_caches
##done
#
#for value in "${my_array_threads_big[@]}"; do
#echo "-------------------- $value --------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#echo "./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is #so cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so #cool?" -t $value --log-file $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multicomp_paper_temp.#log >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
#sync
#sudo echo 3 > /proc/sys/vm/drop_caches
#done

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------- END OF TESTING -------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multicomp_paper.log

############## END OF TESTING ##############

sync
sudo echo 3 > /proc/sys/vm/drop_caches
