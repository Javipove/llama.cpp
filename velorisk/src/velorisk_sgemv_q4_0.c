#include <velorisk.h>
#include <riscv_vector.h>

void velorisk_sgemv_q4_0(int ne01,int ne0, const block_q4_0_velo *x_0,const block_q4_0_velo *x_1,  const float * y, float * dst_temp, int k, int h, int n_blocks ){
    float sumf_0 = 0.0;
    float sumf_1 = 0.0;

    for (int i = 0; i < n_blocks; i+=2){
        const int vl = vsetvl_e8m1(32/2); //QK4_0/2 = qk = 32
         
        vuint8m1_t tx_0_0 = vle8_v_u8m1(x_0[i].qs, vl); //32 int4 values weights
        vuint8m1_t tx_0_1 = vle8_v_u8m1(x_0[i+1].qs, vl);

        vuint8m1_t tx_1_0 = vle8_v_u8m1(x_1[i].qs, vl); //32 int4 values weights
        vuint8m1_t tx_1_1 = vle8_v_u8m1(x_1[i+1].qs, vl);

        vfloat32m4_t y0_0 = vle32_v_f32m4(y+i*32, vl); //16 float values
        vfloat32m4_t y0_1 = vle32_v_f32m4(y+i*32+16, vl); //16 float values

        vfloat32m4_t y1_0 = vle32_v_f32m4(y+(i+1)*32, vl); //16 float values
        vfloat32m4_t y1_1 = vle32_v_f32m4(y+(i+1)*32+16, vl); //16 float values

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

        vint16m2_t vxa_0_0 = vwadd_vx_i16m2(x_ai_0_0, -8, vl); //This is not converted to imm ...
        vint16m2_t vxl_0_0 = vwadd_vx_i16m2(x_li_0_0, -8, vl);
        vint16m2_t vxa_0_1 = vwadd_vx_i16m2(x_ai_0_1, -8, vl);
        vint16m2_t vxl_0_1 = vwadd_vx_i16m2(x_li_0_1, -8, vl);
        vint16m2_t vxa_1_0 = vwadd_vx_i16m2(x_ai_1_0, -8, vl); //This is not converted to imm ...
        vint16m2_t vxl_1_0 = vwadd_vx_i16m2(x_li_1_0, -8, vl);
        vint16m2_t vxa_1_1 = vwadd_vx_i16m2(x_ai_1_1, -8, vl);
        vint16m2_t vxl_1_1 = vwadd_vx_i16m2(x_li_1_1, -8, vl);

        vfloat32m4_t fp_vxa_0_0 = vfwcvt_f_x_v_f32m4(vxa_0_0, vl); //This is not converted to imm ...
        vfloat32m4_t fp_vxl_0_0 = vfwcvt_f_x_v_f32m4(vxl_0_0, vl);
        vfloat32m4_t fp_vxa_0_1 = vfwcvt_f_x_v_f32m4(vxa_0_1, vl);
        vfloat32m4_t fp_vxl_0_1 = vfwcvt_f_x_v_f32m4(vxl_0_1, vl);
        vfloat32m4_t fp_vxa_1_0 = vfwcvt_f_x_v_f32m4(vxa_1_0, vl); //This is not converted to imm ...
        vfloat32m4_t fp_vxl_1_0 = vfwcvt_f_x_v_f32m4(vxl_1_0, vl);
        vfloat32m4_t fp_vxa_1_1 = vfwcvt_f_x_v_f32m4(vxa_1_1, vl);
        vfloat32m4_t fp_vxl_1_1 = vfwcvt_f_x_v_f32m4(vxl_1_1, vl);

        float x_0_scale = velorisk_fp16_to_fp32_zfh(x_0[i].d);
        float x_1_scale = velorisk_fp16_to_fp32_zfh(x_1[i].d);

        fp_vxa_0_0 = vfmul_vf_f32m4(fp_vxa_0_0, x_0_scale, vl); //This is not converted to imm ...
        fp_vxl_0_0 = vfmul_vf_f32m4(fp_vxl_0_0, x_0_scale, vl);
        fp_vxa_0_1 = vfmul_vf_f32m4(fp_vxa_0_1, x_0_scale, vl);
        fp_vxl_0_1 = vfmul_vf_f32m4(fp_vxl_0_1, x_0_scale, vl);
        fp_vxa_1_0 = vfmul_vf_f32m4(fp_vxa_1_0, x_1_scale, vl); //This is not converted to imm ...
        fp_vxl_1_0 = vfmul_vf_f32m4(fp_vxl_1_0, x_1_scale, vl);
        fp_vxa_1_1 = vfmul_vf_f32m4(fp_vxa_1_1, x_1_scale, vl);
        fp_vxl_1_1 = vfmul_vf_f32m4(fp_vxl_1_1, x_1_scale, vl);

        //Now that the have the weights we do int8*int8 widening and then we accumunate
        vfloat32m4_t vec_mul_0_0 = vfmul_vv_f32m4(fp_vxa_0_0, y0_0, vl);
        vfloat32m4_t vec_macc_0_0 = vfmacc_vv_f32m4(vec_mul_0_0,fp_vxl_0_0, y0_1, vl);
        vfloat32m4_t vec_mul_0_1 = vfmul_vv_f32m4(fp_vxa_0_1, y1_0, vl);
        vfloat32m4_t vec_macc_0_1 = vfmacc_vv_f32m4(vec_mul_0_1,fp_vxl_0_1, y1_1, vl);

        vfloat32m4_t vec_mul_1_0 = vfmul_vv_f32m4(fp_vxa_1_0, y0_0, vl);
        vfloat32m4_t vec_macc_1_0 = vfmacc_vv_f32m4(vec_mul_1_0,fp_vxl_1_0, y0_1, vl);
        vfloat32m4_t vec_mul_1_1 = vfmul_vv_f32m4(fp_vxa_1_1, y1_0, vl);
        vfloat32m4_t vec_macc_1_1 = vfmacc_vv_f32m4(vec_mul_1_1,fp_vxl_1_1, y1_1, vl);

        const vfloat32m1_t vec_zero = vfmv_v_f_f32m1(0,16); //Hardcode vl as the different to the setvl

        //We add all the results (the results are spread in 1 vector register) of the same Quantized blocks in 1 number
        vfloat32m1_t v_res_0_0 = vfredosum_vs_f32m4_f32m1( vec_zero, vec_macc_0_0, vec_zero, vl);
        vfloat32m1_t v_res_0_1 = vfredosum_vs_f32m4_f32m1( vec_zero, vec_macc_0_1, vec_zero, vl);
        
        vfloat32m1_t v_res_1_0 = vfredosum_vs_f32m4_f32m1( vec_zero, vec_macc_1_0, vec_zero, vl);
        vfloat32m1_t v_res_1_1 = vfredosum_vs_f32m4_f32m1( vec_zero, vec_macc_1_1, vec_zero, vl);

        sumf_0 += vfmv_f_s_f32m1_f32(v_res_0_0) + vfmv_f_s_f32m1_f32(v_res_0_1);
        sumf_1 += vfmv_f_s_f32m1_f32(v_res_1_0) + vfmv_f_s_f32m1_f32(v_res_1_1);
    }
                
    *(dst_temp+h+k*ne0) = sumf_0;
    *(dst_temp+(h+1)+k*ne0) = sumf_1;
}
