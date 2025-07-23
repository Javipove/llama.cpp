#!/bin/bash

#THIS CODE RUNS LLAMA.CPP

export OPENBLAS_PATH=/scratch/jpoveda/simple_vectorization/OpenBlas_910V_MOD_Mem_NoFortran
export LLAMA_HOME=/scratch/jpoveda/llama_rebase/llama.cpp
export VELORISK_HOME=$LLAMA_HOME/velorisk

export BASE_CC_PATH_CLANG=/scratch/tools/llvm-project/build
export MODEL_HOME=/scratch/tools/models

export LD_LIBRARY_PATH=$VELORISK_HOME/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/scratch/jpoveda/veloRISK/llama.cpp-dev/velorisk/lib:$LD_LIBRARY_PATH

export CLANG_FLAGS="-march=rv64gc_zfh_xtheadba_xtheadbb_xtheadbs_xtheadcmo_xtheadcondmov_xtheadfmemidx_xtheadmac_xtheadmemidx_xtheadmempair_xtheadsync --gcc-install-dir=/usr/lib/gcc/riscv64-redhat-linux/13/"

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1

cd $LLAMA_HOME
echo "this programm requires SUDO"

#echo 0 > /proc/sys/kernel/numa_balancing

###Setting up system
#cd $VELORISK_HOME
#pwd
#make clean
#make all VELORISK_USE_API=$1
#cd $LLAMA_HOME
#pwd
#cmake --build build --target clean
#cmake -B build --fresh -DCMAKE_C_COMPILER=$BASE_CC_PATH_CLANG/bin/clang \
#    -DCMAKE_CXX_COMPILER=$BASE_CC_PATH_CLANG/bin/clang++ \
#    -DCMAKE_C_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
#    -DCMAKE_CXX_FLAGS="$CLANG_FLAGS -I$BASE_CC_PATH_CLANG/include  -I$VELORISK_HOME/include -DVARIABLE_VALUE=4096 -DVELORISK_COMPLEX -DUSE_VELORISK " \
#    -DCMAKE_EXE_LINKER_FLAGS="-lvelorisk -L$BASE_CC_PATH_CLANG/lib -L$VELORISK_HOME/lib" \
#    -DGGML_OPENMP=OFF -DUSE_VELORISK=1 -DGGML_CCACHE=OFF -DGGML_RVV=OFF --target llama-cli\
#
#cmake --build build --config Release -j 32 --target llama-cli
#
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "1 thread --physcpubind=0  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --physcpubind=0 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64  -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 1 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "2 thread --physcpubind=0-1  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --physcpubind=0-1 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 2 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "4 thread --physcpubind=0-3  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl  --physcpubind=0-3 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 4 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "8 thread --physcpubind=0-7  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl  --physcpubind=0-7 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 8 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "16 thread --cpubind=3  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --cpubind=3 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256  -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 16 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "32 thread --cpubind=2,3  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --cpubind=2,3 -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 32 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "32 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
# ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256  -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 32 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "64 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "64 thread   TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
# ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256  -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "------- 32 threads extra testing ---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "32 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
## ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so #cool?" -t 32 -log-enable >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/#esults_inference_multi_numa.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "32 thread --cpubind=2,3 --membind=2,3  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##numactl --cpubind=2,3 --membind=2,3 --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a ime, there was a kingdom' -t 32 #--log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/#esults_inference_multi_numa.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "32 thread --cpubind=2,3   TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##numactl --cpubind=2,3 --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was a ingdom' -t 32 --log-file #$VELORISK_HOME/tests/llama/results_inference_multi_numa.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/#esults_inference_multi_numa.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##echo "32 thread --interleave=all   TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
##numactl --interleave=all --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there as a kingdom' -t 32 --log-file #$VELORISK_HOME/tests/llama/results_inference_multi_numa.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/#esults_inference_multi_numa.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa.log
#
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "------- Numa interleave testing ---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "1 thread --interleave=0,1  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl  --interleave=0,1 --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 1 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "2 thread --interleave=0,1  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl  --interleave=0,1  --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there #was a kingdom' -t 2 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "4 thread --interleave=0,1  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl  --interleave=0,1 --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 4 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "8 thread --interleave=0,1  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl  --interleave=0,1 --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 8 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "16 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl --interleave=all --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 16 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "32 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl --interleave=all --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 32 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##
##sync
##echo 3 > /proc/sys/vm/drop_caches
##echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##echo "64 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
##numactl --interleave=all --  ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 80  -p 'Once upon a time, there was #a kingdom' -t 64 --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
###grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/#llama/results_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "------- Interleave all ---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "1 thread --interleave=all TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 1 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "2 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 2 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "4 thread --interleave=all  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 4 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "8 thread --interleave=all TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 8 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "16 thread --interleave=all TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 16 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "32 thread --interleave=all TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 32 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "64 thread --interleave=all TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#numactl --interleave=all -- ./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "------- Only no NUMA BALANCING all ---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "1 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 1 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "2 thread   TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 2 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "4 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 4 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "8 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 8 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "16 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 16 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "32 thread TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 32 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
###cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#
#sync
#echo 3 > /proc/sys/vm/drop_caches
#echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#echo "64 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
#./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
#grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
#
#
#
#echo "LEAVING SYSTEM AS DEFAULT"
#sync
#echo 3 > /proc/sys/vm/drop_caches
#
#echo 1 > /proc/sys/kernel/numa_balancing
#

echo 1 > /proc/sys/kernel/numa_balancing
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "------- NUMA BALANCING OG ---------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "1 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 1 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log


sync
echo 3 > /proc/sys/vm/drop_caches

echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "2 thread   TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 2 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "4 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 64 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 4 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "8 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 8 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "16 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 16 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "32 thread TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 32 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
##cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log

sync
echo 3 > /proc/sys/vm/drop_caches
echo "------------------------------------------- TITLE" >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
echo "64 thread  TITLE"  >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/esults_inference_multi_numa_paper.log
