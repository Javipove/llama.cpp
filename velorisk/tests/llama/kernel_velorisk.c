//This is going to be a q4 vs q8 kernel



#include <riscv_vector.h>
#include <stdio.h>
#include <string.h>

inline float ggml_compute_fp16_to_fp32_zfh( _Float16* h) {
    _Float16 tmp;
    memcpy(&tmp, &h, sizeof(_Float16));
    return (float)tmp;
}

void kernel( int ne01, int nb01, const char* x_0, const char* x_1 , const char* y , float* sumf_0, float* sumf_1, _Float16* x_0_d, _Float16* x_1_d, _Float16* y_d){
           // load elements
            int vl = vsetvl_e8m1(32/2); //QK4_0/2 = qk = 32 
            vuint8m1_t tx_0 = vle8_v_u8m1(x_0, vl); //32 int4 values weights
            vuint8m1_t tx_1 = vle8_v_u8m1(x_1, vl); //32 int4 values weights

            vint8m1_t y0 = vle8_v_i8m1(y, vl); //16 int8 values
            vint8m1_t y1 = vle8_v_i8m1(y+vl, vl); //16 16 int8 values


            // mask and store lower part of x, and then upper part
            vuint8m1_t x_a_0 = vand_vx_u8m1(tx_0, 0x0F, vl);
            vuint8m1_t x_l_0 = vsrl_vx_u8m1(tx_0, 0x04, vl);
            vuint8m1_t x_a_1 = vand_vx_u8m1(tx_1, 0x0F, vl);
            vuint8m1_t x_l_1 = vsrl_vx_u8m1(tx_1, 0x04, vl);



            vint8m1_t x_ai_0 = vreinterpret_v_u8m1_i8m1(x_a_0);
            vint8m1_t x_li_0 = vreinterpret_v_u8m1_i8m1(x_l_0);
            vint8m1_t x_ai_1 = vreinterpret_v_u8m1_i8m1(x_a_1);
            vint8m1_t x_li_1 = vreinterpret_v_u8m1_i8m1(x_l_1);
     
            // subtract offset


            vint8m1_t vxa_0 = vadd_vx_i8m1(x_ai_0, -8, vl);
            vint8m1_t vxl_0 = vadd_vx_i8m1(x_li_0, -8, vl);
            vint8m1_t vxa_1 = vadd_vx_i8m1(x_ai_1, -8, vl);
            vint8m1_t vxl_1 = vadd_vx_i8m1(x_li_1, -8, vl);



        //number of vector registers required
        //inputs
        //  x (vxa,vxl) = 4*2 = 8 (can be reused after)
        // y (y0,y1)  = 2 (can be reused after)
        // zero = 1
        // outputs
        // vec_mul = 2 * 4 = 8 (can be reused)
        // sum_mul2 = 2 * 4 = 8
        // redux = 4 
        // TOTAL = 31

            vint16m2_t vec_mul_0 = vwmul_vv_i16m2(vxa_0, y0, vl);
            vint16m2_t vec_macc_0 = vwmacc_vv_i16m2(vec_mul_0,vxl_0, y1, vl);
            vint16m2_t vec_mul_1 = vwmul_vv_i16m2(vxa_1, y0, vl);
            vint16m2_t vec_macc_1 = vwmacc_vv_i16m2(vec_mul_1,vxl_1, y1, vl);


            vint32m1_t vec_zero = vmv_v_x_i32m1(0, vl); //Hardcode vl as the different to the setvl
	        vint32m1_t mask = vmv_v_x_i32m1(
                            0xffffffff,
                            //0x00000000,
                            vl);


            vint32m1_t v_res_0 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_0, vec_zero, vl);
            vint32m1_t v_res_1 = vwredsum_vs_i16m2_i32m1(mask, vec_macc_1, vec_zero, vl);


            int sumi_0 = vmv_x_s_i32m1_i32(v_res_0);
            int sumi_1 = vmv_x_s_i32m1_i32(v_res_1);


            float y__d = ggml_compute_fp16_to_fp32_zfh(y_d);
            *sumf_0 += sumi_0*ggml_compute_fp16_to_fp32_zfh(x_0_d)*y__d;
            *sumf_1 += sumi_1*ggml_compute_fp16_to_fp32_zfh(x_1_d)*y__d;

    return;
 }



