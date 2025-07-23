# VELORISK

New library tailored for Tall And Skinny Matrixes for RISC-V architectures with a vector unit, currently developing matrix vec kernels.



### Old Make recipie
make CC=/scratch/tools/compilers/xuantie_gcc/bin/riscv64-unknown-linux-gnu-gcc CXX=/scratch/tools/compilers/xuantie_gcc/bin/riscv64-unknown-linux-gnu-g++ CFLAGS="-mcpu=c920 -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I/scratch/tools/frameworks/llama.cpp/velorisk/include" CXXFLAGS="-mcpu=c920 -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I/scratch/tools/compilers/xuantie_gcc/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I/scratch/tools/frameworks/llama.cpp/velorisk/include" LDFLAGS="-lvelorisk -L/scratch/tools/compilers/xuantie_gcc/lib -L/scratch/tools/compilers/xuantie_gcc/lib64 -L/scratch/tools/frameworks/llama.cpp/velorisk/lib" -j 32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 PKG_CONFIG_PATH="/scratch/jpoveda/OpenBLAS_910V_Default_V0326_Cross/lib/pkgconfig/" 

### Relevant Files
The actual hand-optimized kernel (compiled with GCC 14 and modified by hand in order to be able to compile the ASM it with Xuantie GCC 10.4 (Binutils of GCC14 were not uptodate at that moment for "th." instructions)):
/src/kernel_velorisk_complex2.S

The corresponding C code:
/src/velorisk_sgemv_q4_0.c 

This i


LLAMA_OPENBLAS is optional

To just compile it check tests/llama/compile.sh There are multiple options with CLANG and GCC

The kernel used currently has been generated with GCC 14 