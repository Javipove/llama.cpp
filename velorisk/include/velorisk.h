#include <stdint.h>
#include <string.h>
#include <stdio.h>

inline float velorisk_fp16_to_fp32_zfh( const _Float16 h) {
    _Float16 tmp;
    memcpy(&tmp, &h, sizeof(_Float16));
    return (float)tmp;
}

#define QK8_0_vel 32
typedef struct {
    _Float16   d;          // delta
    int8_t  qs[QK8_0_vel];  // quants
} block_q8_0_velo;

#define QK4_0_vel 32
typedef struct {
    _Float16   d;          // delta
    uint8_t qs[QK4_0_vel / 2];  // nibbles / quants
} block_q4_0_velo;

/* Matrix-vector multiplication  A x B = C
* A  [A_N x  A_M] where A_N = A_M
* B  [B_N x 1]
* C  [A_N x 1]
*
* 
* |+ + + + |+ + + + |+ + + + |+ + + + | ->     V1 V2 V3 V4 ... 
* |</
* |...
*
*
* |+| ->     V16 V17 V18 V19 ...
* |+|
* |+|
* |+|
* ---
* |.|
* |.|
*
*
**|+| ->     Redu (V1 V2 V3 V4) ...
* ---
* |.|
* ---
* |.|
* ---
* |.|
* ---
* |.|
* |.|
*
*
*
*/


void velorisk_f32f32_matvec_rmajor_m1(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_rmajor_m4_m1_unorder(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_rmajor_m4_m1_order(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_rmajor_m4_unrolled(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_rmajor_m2_reusage_vstore(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_cmajor_m1(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_cmajor_m2(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matvec_cmajor_unrolled_m2(float * A, float * B, float * C, int A_M, int A_N );

void velorisk_f32f32_matmat(float* mat_a, float* mat_b, float* mat_res, int a_transposed, int b_transposed,
                                    int a_width, int a_height, int b_height);

void velorisk_f32f32(float* mat_a, float* mat_b, float* mat_res, int a_transposed, int b_transposed,
                                    int a_width, int a_height, int b_height);

//void kernel( int ne01, int nb01, const char* x_0, const char* x_1 , const char* y , float* dst_temp,int h, _Float16* x_0_d, _Float16* x_1_d, _Float16* y_d, int n_blocks);

//void kernel( int ne01, int nb01, const char* x_0, const char* x_1 , const char* y , float* sumf_0, float* sumf_1, _Float16* x_0_d, _Float16* x_1_d, _Float16* y_d);

void kernel( int ne01, int nb01, const char* x_0_1, const char* x_0_0, const char* x_1_0,const char* x_1_1 , const char* y_0 , const char* y_1 , float* sumf_0, float* sumf_1, _Float16* x_00_d, _Float16* x_01_d, _Float16* x_10_d, _Float16* x_11_d, _Float16* y_0_d, _Float16* y_1_d);

void kernel_complex(int ne01,int ne0, const block_q4_0_velo *x_0,const block_q4_0_velo *x_1,  const block_q8_0_velo * y, float * dst_temp, int k, int h, int n_blocks );

void velorisk_sgemv_q4_0(int ne01,int ne0, const block_q4_0_velo *x_0,const block_q4_0_velo *x_1,  const float * y, float * dst_temp, int k, int h, int n_blocks );

void quantize_row_q8_0_velorisk(const float * x, block_q8_0_velo * restrict vy, int64_t k);

