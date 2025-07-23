#!/bin/bash
export LD_LIBRARY_PATH=$VELORISK_HOME/lib
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
for i in {0..9..1}
do
    cd $VELORISK_HOME
    pwd
    make clean
    make all VELORISK_USE_API=$i
    cd $LLAMA_HOME
    pwd
    make clean
    make CC=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-gcc \
         CXX=$BASE_CC_PATH/bin/riscv64-unknown-linux-gnu-g++ \
         CFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include" \
         CXXFLAGS="-mcpu=c920 -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include -I$BASE_CC_PATH/lib/gcc/riscv64-unknown-linux-gnu/10.4.0/include-fixed -I$VELORISK_HOME/include" \
         LDFLAGS="-lvelorisk -L$BASE_CC_PATH/lib -L$BASE_CC_PATH/lib64 -L$VELORISK_HOME/lib" \
         -j32 LLAMA_OPENMP=OFF LLAMA_OPENBLAS=1 LLAMA_NO_OPENMP=1 USE_VELORISK=1 \
         PKG_CONFIG_PATH="$OPENBLAS_PATH/lib/pkgconfig/" \
         veloriskmmul benchmark-matmult
        #./veloriskmmul
    echo "Iteration with API $i " >> ./velorisk_bench_perf.log
    echo "-----------------------" >> ./velorisk_bench_perf.log
    echo "Iteration with API $i"
     perf stat -d -- ./benchmark-matmult -t 1 > ./velorisk_bench_perf.log 2>&1
    echo "----------------------------------------" >> ./velorisk_bench_perf.log
    echo "----------------------------------------" >> ./velorisk_bench_perf.log
    echo "Done iteration with API $i"
done