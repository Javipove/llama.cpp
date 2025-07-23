# VELORISK

New library tailored for Tall And Skinny Matrixes for RISC-V architectures with a vector unit, currently developing matrix vec kernels.


## Relevant Files
### GEMV Kernel Specific
- The actual hand-optimized kernel (compiled with GCC 14 and modified by hand in order to be able to compile the ASM it with Xuantie GCC 10.4 (Binutils of GCC14 were not uptodate at that moment for "th." instructions)) ***/src/kernel_velorisk_complex2.S***

- The corresponding C code in ***/src/velorisk_sgemv_q4_0.c***
### Compiling Specific
The different compiling and running recipies for different configurations (the other .sh were used for individual testing so I can't asure they work, they ones testes and used at the end are these ones):

- Diffenent compiler used: ***tests/llama/run_inference_multicomp.sh***
- CLANG 19 compiler but different NUMA strategies: ***tests/llama/run_inference_multi_numa_2.sh***

### GGML Kernel insertion
Our customized kernel for GEMV Q4_0 is inserted in ***ggml-cpu.c*** . We intecept the normal flow of execution of llama.cpp when it doesn't have a specific backend, and we apply our kernel and return (probably not the best implementation but it works). 

### Relevant Notes
Due to the compilation with Xuantie GCC that would define `__riscv_v_intrinsic` and llama.cpp will try to use integrated kernels for rvv 1.0, which will break the compilation. So it was modified the  `__riscv_v_intrinsic` flag in the ggml code to `__riscv_v_intrinsic_test` to avoid it.

For the compilation with Xuantie GCC 10.2 with this version of llama.cpp I was only able to make it work with a customized Makefile, so check the changes. CLANG 19 and the native GCC 13 work with the cmake fine. 

#### Logging
In this version I didn't add the logging with perf for the little rush, but in order to get it you can combine the numa+perf+llamacpp inference with this example for the **old infra**: 
```console
numactl --interleave=all -- perf stat -d -d -o ./perf.txt -- ./main -m $MODEL_HOME/llama-2-7b.Q4_0.gguf -n 80  -p 'Once upon a time, there was a kingdom' -t 2 --log-enable >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
grep -w -E "Cmd:|system_info:|llama_print_timings:|main: built with" /scratch/jpoveda/veloRISK/llama.cpp-dev/main.log >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
```
And this is the one that can be used with **this version of llama.cpp** (perf logging was not used this time but I added it here in case you want to use it):
```console
numactl --interleave=all -- perf stat -d -d -o ./perf.txt --./build/bin/llama-cli -m $MODEL_HOME/DeepSeek-R1-Distill-Llama-8B-Q4_0.gguf -n 256 -b 512 -no-cnv -p "Explain to me what is RISC-V, what are its principles and why it is so cool?" -t 64 -b 512 -no-cnv --log-file $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log
grep -w -E "Cmd:|system_info:|llama_perf_context_print:|llama_perf_sampler_print:|main: built with|build:" $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper_temp.log >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
cat ./perf.txt >> $VELORISK_HOME/tests/llama/results_inference_multi_numa_paper.log
```
little logging example with the old infra at [example](tests/llama/example_log_llama_perf.txt)
#### Matmul evaluation
In order to test the improvements of the new kernel we used the **benchmark-matmult** code already integrated in llama.cpp in previous veriosns. This allow for rapit matmul performance analisis and the .cpp code allows to modify easily the datatypes to check the Q4_0 x FP32 performance with different dimensions. Here is the commit where it was deleted in case you want to rescue it: [benchmar:-matmul](https://github.com/ggml-org/llama.cpp/commit/148844fe97fff4c1563a3111bf238ba4dd22ef56)

#### Per-OP analisys
In order to have a fine grain perfomance timings of each layer and operations it can be used the LLAMA_PERF flag in order to have this timings, which can be really usefull for this analysis:
[llama_perf per op analysis](https://github.com/ggml-org/llama.cpp/pull/9355/commits)


----
## Old Make recipie and Notes (PROBABLY DEPRECIADED)
make CC=/scratch/tools/compilers/xuantie_gcc/bin/riscv64-unknown-linux-gnu-gcc CXX=/scratch/tools/compilers/xuantie_gcc/bin/riscv64-unknown-linux-gnu-g++ CFLAGS="-mcpu=c920 -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I/scratch/tools/frameworks/llama.cpp/velorisk/include" CXXFLAGS="-mcpu=c920 -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I/scratch/tools/frameworks/llama.cpp/velorisk/include" LDFLAGS="-lvelorisk -L/scratch/tools/compilers/xuantie_gcc/lib -L/scratch/tools/compilers/xuantie_gcc/lib64 -L/scratch/tools/frameworks/llama.cpp/velorisk/lib" -j 32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 PKG_CONFIG_PATH="/scratch/jpoveda/OpenBLAS_910V_Default_V0326_Cross/lib/pkgconfig/" 

LLAMA_OPENBLAS is optional

To just compile it check tests/llama/compile.sh There are multiple options with CLANG and GCC

The kernel used currently has been generated with GCC 14 