


#include <riscv_vector.h>
#include <stdio.h>
#include <string.h>

#define QK8_0 32
typedef struct {
    float   d;          // delta
    int8_t  qs[QK8_0];  // quants
} block_q8_0;

#define QK4_0 32
typedef struct {
    float   d;          // delta
    uint8_t qs[QK4_0 / 2];  // nibbles / quants
} block_q4_0;

inline float ggml_compute_fp16_to_fp32_zfh( const _Float16 h) {
    _Float16 tmp;
    memcpy(&tmp, &h, sizeof(_Float16));
    return (float)tmp;
}


void kernel_complex(int ne01,int ne0, const block_q4_0 *x_0,const block_q4_0 *x_1,  const block_q8_0 * y, float * dst_temp, int k, int h, int n_blocks ){
        float sumf_0 = 0.0;
        float sumf_1 = 0.0;
        //float sumf_2 = 0.0;
        //float sumf_3 = 0.0;
        //first impl -> currently NB must be even

            for (int i = 0; i < n_blocks; i+=2){
            const int vl = vsetvl_e8m1(32/2); //QK4_0/2 = qk = 32
            //kernel_in(ne01, x_0_1, x_0_0, x_1_0,x_1_1 , y_0 ,y_1 , &sumf_0, &sumf_1, x_00_d, x_01_d, x_10_d, x_11_d,  y_0_d,  y_1_d);
             
            vuint8m1_t tx_0_0 = vle8_v_u8m1(x_0[i].qs, vl); //32 int4 values weights
            vuint8m1_t tx_0_1 = vle8_v_u8m1(x_1[i+1].qs, vl);

            vuint8m1_t tx_1_0 = vle8_v_u8m1(x_1[i].qs, vl); //32 int4 values weights
            vuint8m1_t tx_1_1 = vle8_v_u8m1(x_1[i+1].qs, vl);

            vint8m1_t y0_0 = vle8_v_i8m1(y[i].qs, vl); //16 int8 values
            vint8m1_t y0_1 = vle8_v_i8m1(y[i].qs+vl, vl); //16 16 int8 values

            vint8m1_t y1_0 = vle8_v_i8m1(y[i+1].qs, vl); //16 int8 values
            vint8m1_t y1_1 = vle8_v_i8m1(y[i+1].qs+vl, vl); //16 16 int8 values

            //DEQUANTIZING
            //SPLITING THE INT8 INTO 2 INT4
            vuint8m1_t x_a_0_0 = vand_vx_u8m1(tx_0_0, 0x0F, vl);
            vuint8m1_t x_l_0_0 = vsrl_vx_u8m1(tx_0_0, 0x04, vl);
            vuint8m1_t x_a_0_1 = vand_vx_u8m1(tx_0_1, 0x0F, vl);
            vuint8m1_t x_l_0_1 = vsrl_vx_u8m1(tx_0_1, 0x04, vl);
            vuint8m1_t x_a_1_0 = vand_vx_u8m1(tx_1_0, 0x0F, vl);
            vuint8m1_t x_l_1_0 = vsrl_vx_u8m1(tx_1_0, 0x04, vl);
            vuint8m1_t x_a_1_1 = vand_vx_u8m1(tx_1_1, 0x0F, vl);
            vuint8m1_t x_l_1_1 = vsrl_vx_u8m1(tx_1_1, 0x04, vl);

            //Reinterpret
            vint8m1_t x_ai_0_0 = vreinterpret_v_u8m1_i8m1(x_a_0_0);
            vint8m1_t x_li_0_0 = vreinterpret_v_u8m1_i8m1(x_l_0_0);
            vint8m1_t x_ai_0_1 = vreinterpret_v_u8m1_i8m1(x_a_0_1);
            vint8m1_t x_li_0_1 = vreinterpret_v_u8m1_i8m1(x_l_0_1);
            vint8m1_t x_ai_1_0 = vreinterpret_v_u8m1_i8m1(x_a_1_0);
            vint8m1_t x_li_1_0 = vreinterpret_v_u8m1_i8m1(x_l_1_0);
            vint8m1_t x_ai_1_1 = vreinterpret_v_u8m1_i8m1(x_a_1_1);
            vint8m1_t x_li_1_1 = vreinterpret_v_u8m1_i8m1(x_l_1_1);

            vint8m1_t vxa_0_0 = vadd_vx_i8m1(x_ai_0_0, -8, vl); //This is not converted to imm ...
            vint8m1_t vxl_0_0 = vadd_vx_i8m1(x_li_0_0, -8, vl);
            vint8m1_t vxa_0_1 = vadd_vx_i8m1(x_ai_0_1, -8, vl);
            vint8m1_t vxl_0_1 = vadd_vx_i8m1(x_li_0_1, -8, vl);
            vint8m1_t vxa_1_0 = vadd_vx_i8m1(x_ai_1_0, -8, vl); //This is not converted to imm ...
            vint8m1_t vxl_1_0 = vadd_vx_i8m1(x_li_1_0, -8, vl);
            vint8m1_t vxa_1_1 = vadd_vx_i8m1(x_ai_1_1, -8, vl);
            vint8m1_t vxl_1_1 = vadd_vx_i8m1(x_li_1_1, -8, vl);

            //Now that the have the weights we do int8*int8 widening and then we accumunate
            vint16m2_t vec_mul_0_0 = vwmul_vv_i16m2(vxa_0_0, y0_0, vl);
            vint16m2_t vec_macc_0_0 =vwmacc_vv_i16m2(vec_mul_0_0,vxl_0_0, y0_1, vl);
            vint16m2_t vec_mul_0_1 = vwmul_vv_i16m2(vxa_0_1, y1_0, vl);
            vint16m2_t vec_macc_0_1 =vwmacc_vv_i16m2(vec_mul_0_1,vxl_0_1, y1_1, vl);

            vint16m2_t vec_mul_1_0 = vwmul_vv_i16m2(vxa_1_0, y0_0, vl);
            vint16m2_t vec_macc_1_0 =vwmacc_vv_i16m2(vec_mul_1_0,vxl_1_0, y0_1, vl);
            vint16m2_t vec_mul_1_1 = vwmul_vv_i16m2(vxa_1_1, y1_0, vl);
            vint16m2_t vec_macc_1_1 = vwmacc_vv_i16m2(vec_mul_1_1,vxl_1_1, y1_1, vl);

            const vint32m1_t vec_zero = vmv_v_x_i32m1(0,16); //Hardcode vl as the different to the setvl

            //We add all the results (the results are spread in 1 vector register) of the same Quantized blocks in 1 number
	        const vint32m1_t mask = vmv_v_x_i32m1(
                            0xffffffff,
                            //0x00000000,
                            vl);

            vint32m1_t v_res_0_0 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_0_0, vec_zero, vl);
            vint32m1_t v_res_0_1 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_0_1, vec_zero, vl);
            
            vint32m1_t v_res_1_0 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_1_0, vec_zero, vl);
            vint32m1_t v_res_1_1 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_1_1, vec_zero, vl);
            
            //vint32m1_t v_res_2 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_2, vec_zero, vl);
            //vint32m1_t v_res_3 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_3, vec_zero, vl);

            int sumi_0_0 = vmv_x_s_i32m1_i32(v_res_0_0);
            int sumi_0_1 = vmv_x_s_i32m1_i32(v_res_0_1);
            int sumi_1_0 = vmv_x_s_i32m1_i32(v_res_1_0);
            int sumi_1_1 = vmv_x_s_i32m1_i32(v_res_1_1);
            //int sumi_2 = vmv_x_s_i32m1_i32(v_res_2);
            //int sumi_3 = vmv_x_s_i32m1_i32(v_res_3);

            //FOR TESTING ONLY FLOATING UNCOMMENT THE FOLLOWING LINES
            //float y_d = GGML_FP16_TO_FP32(y[i].d);
            //sumf_0 += i*GGML_FP16_TO_FP32(x_0[i].d)*y_d;
            //sumf_1 += i*GGML_FP16_TO_FP32(x_1[i].d)*y_d;
            float y_d_0 = ggml_compute_fp16_to_fp32_zfh(y[i].d);
            float y_d_1 = ggml_compute_fp16_to_fp32_zfh(y[i+1].d);
            //We multiply each result, by its dequantizing scale of x (4 blocks ) and y (2blocks)
            sumf_0 += sumi_0_0*ggml_compute_fp16_to_fp32_zfh(x_0[i].d)*y_d_0 + sumi_0_1*ggml_compute_fp16_to_fp32_zfh(x_0[i+1].d)*y_d_1;
            sumf_1 += sumi_1_0*ggml_compute_fp16_to_fp32_zfh(x_1[i].d)*y_d_0 + sumi_1_1*ggml_compute_fp16_to_fp32_zfh(x_1[i+1].d)*y_d_1;
            }   //nb = number of bytes per row
                
            *(dst_temp+h+k*ne0) = sumf_0;
            *(dst_temp+(h+1)+k*ne0) = sumf_1;
 }

