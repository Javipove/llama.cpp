#include <velorisk.h>
#include <riscv_vector.h>
#include  <stdio.h> //TO DELETE

/* Matrix-vector multiplication  A x B = C
* B  [B_N x  B_M] where B_N = B_M
* A  [A_N x 1]
* C  [B_N x 1]
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

extern void velogpt_matvec_mult(const float *A, const float *x, float *y, int n, int m);

extern void kernel( int ne01, int nb01, const char* x_0_1, const char* x_0_0, const char* x_1_0,const char* x_1_1 , const char* y_0 , const char* y_1 , float* sumf_0, float* sumf_1, _Float16* x_00_d, _Float16* x_01_d, _Float16* x_10_d, _Float16* x_11_d, _Float16* y_0_d, _Float16* y_1_d);
extern void kernel_complex(int ne01,int ne0, const block_q4_0_velo *x_0,const block_q4_0_velo *x_1,  const block_q8_0_velo * y, float * dst_temp, int k, int h, int n_blocks );
//extern void kernel( int ne01, int nb01, const char* x_0, const char* x_1 , const char* y , float* sumf_0, float* sumf_1, _Float16* x_0_d, _Float16* x_1_d, _Float16* y_d);
//extern void kernel( int ne01, int nb01, const char* x_0, const char* x_1 , const char* y , float* dst_temp, int h, _Float16* x_0_d, _Float16* x_1_d, _Float16* y_d, int n_blocks);
/* Row-major implementation, iwth a moving thourough a unique row of the square matric
*  Using The following number of Vector Regs
*  vec_acc: 1*M1 = 1
*  vec_0: 1*M1 = 1
*  vec_A: 1*M1 = 1
*  vec_B: 1*M1 = 1
*  mask: 1*M1 = 1
*  result: 1*M1 = 1
*  
*  Total: 6
* 
*/

void velorisk_f32f32_matvec_rmajor_m1(float * A, float * B, float * C, int B_M, int B_N ){
    int gvl = vsetvl_e32m1(B_M);
    for(int i = 0; i < B_N; i++){ //We generate 1 result at a time
        int j = 0;
        vfloat32m1_t vec_acc = vfmv_v_f_f32m1(0, gvl);
        vfloat32m1_t vec_0 =vfmv_v_f_f32m1(0, gvl);
        for(int k = 0; k < B_M/gvl; k++){
            vfloat32m1_t vec_A = vle32_v_f32m1(&A[j], gvl);
            vfloat32m1_t vec_B = vle32_v_f32m1(&B[j], gvl);
            vec_acc = vfmacc_vv_f32m1(vec_acc, vec_A, vec_B , gvl);                
            j += gvl;
        }
        vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, gvl);
        vfloat32m1_t v_res = vfredusum_vs_f32m1_f32m1(mask, vec_acc, vec_0, gvl);
        C[i]= (float)vfmv_f_s_f32m1_f32(v_res);
    }
}



/* Row-major implementation with mixed M1 AND M4 to reduce the usage of vec registes, iwth a moving thourough a unique row of the square matric
*  Using The following number of Vector Regs
*  vec_acc: 1*M4 = 4
*  vec_0: 1*M1 = 1 
*  vec_A: 1*M4 = 4
*  vec_B: 1*M4 = 4
*  mask: 1*M1 = 1 
*  result: 1*M1 = 1  4
*  
*  Total: 15 
* 
*/

void velorisk_f32f32_matvec_rmajor_m4_m1_unorder(float * A, float * B, float * C, int B_M, int B_N ){
    vfloat32m1_t vec_0 =vfmv_v_f_f32m1(0, 4);
    int gvl = vsetvl_e32m4(B_M);
    for(int i = 0; i < B_N; i++){ //We generate 1 result at a time
        int j = 0;
        vfloat32m4_t vec_acc = vfmv_v_f_f32m4(0, gvl);
        for(int k = 0; k < B_M/gvl; k++){
            vfloat32m4_t vec_A = vle32_v_f32m4(&A[j], gvl);
            vfloat32m4_t vec_B = vle32_v_f32m4(&B[j], gvl);
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A, vec_B , gvl);                
            j += gvl;
        }
        vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, 4);
        vfloat32m1_t v_res = vfredusum_vs_f32m4_f32m1(mask, vec_acc, vec_0, gvl);
        C[i]= (float)vfmv_f_s_f32m1_f32(v_res);
    }
}


/* Row-major implementation using purely M4 even if it may be not needed, iwth a moving thourough a unique row of the square matric
*  Using The following number of Vector Regs
*  vec_acc: 1*M4 = 4
*  vec_0: 1*M4 = 4 we are using M4 in the end 4
*  vec_A: 1*M4 = 4
*  vec_B: 1*M4 = 4
*  mask: 1*M4 = 4   we are using M4 in the end 4 4
*  result: 1*M1 = 1
*  
*  Total: 
* 
*/

void velorisk_f32f32_matvec_rmajor_m4_m1_order(float * A, float * B, float * C, int B_M, int B_N ){
    vfloat32m1_t vec_0 = vfmv_v_f_f32m1(0, 4);
    int gvl = vsetvl_e32m4(B_M);
    for(int i = 0; i < B_N; i++){ //We generate 1 result at a time
        int j = 0;
        vfloat32m4_t vec_acc = vfmv_v_f_f32m4(0, gvl);
        for(int k = 0; k < B_M/gvl; k++){
            vfloat32m4_t vec_A = vle32_v_f32m4(&A[j], gvl);
            vfloat32m4_t vec_B = vle32_v_f32m4(&B[j], gvl);
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A, vec_B , gvl);                
            j += gvl;
        }
        vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, 4);
        vfloat32m1_t v_res = vfredosum_vs_f32m4_f32m1(mask, vec_acc, vec_0, gvl);
        C[i]= (float)vfmv_f_s_f32m1_f32(v_res);
    }
}




/* Row-major implementation unrolled, with a moving thourough a unique row of the square matric
*  Using The following number of Vector Regs
*  vec_acc: 1*M4 = 4
*  vec_0: 1*M1 = 1
*  vec_A: 3*M4 = 12
*  vec_B: 3*M4 = 12
*  mask: 1*M1 = 1
*  result: 1*M1 = 1
*  
*  Total: 31
* 
*/
void velorisk_f32f32_matvec_rmajor_m4_unrolled(float * A, float * B, float * C, int B_M, int B_N ){
    vfloat32m1_t vec_0 = vfmv_v_f_f32m1(0, 4);
    vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, 4);
    int gvl = vsetvl_e32m4(B_M);
    for(int i = 0; i < B_N; i++){ //We generate 1 result at a time
        int j = 0;
        vfloat32m4_t vec_acc = vfmv_v_f_f32m4(0, gvl);
        for(int k = 0; k < B_M/(gvl*3); k++){
            vfloat32m4_t vec_A_0 = vle32_v_f32m4(&A[j], gvl);
            vfloat32m4_t vec_A_1 = vle32_v_f32m4(&A[j+gvl], gvl);
            vfloat32m4_t vec_A_2 = vle32_v_f32m4(&A[j+gvl+gvl], gvl);
            vfloat32m4_t vec_B_0 = vle32_v_f32m4(&B[j], gvl);
            vfloat32m4_t vec_B_1 = vle32_v_f32m4(&B[j+gvl], gvl);
            vfloat32m4_t vec_B_2 = vle32_v_f32m4(&B[j+gvl+gvl], gvl);
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_0, vec_B_0 , gvl);    
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_1, vec_B_1 , gvl);  
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_2, vec_B_2 , gvl);              
            j += gvl+gvl+gvl;
        }
        vfloat32m1_t v_res = vfredusum_vs_f32m4_f32m1(mask, vec_acc, vec_0, gvl);
        C[i]= (float)vfmv_f_s_f32m1_f32(v_res);
    }
}


/* Row-major implementation with strided load to increase data reusage,moving thourough a 2 rows of the square matric
*  Using The following number of Vector Regs
*  vec_acc: 4*M2= 8
*  vec_0: 1*M1 = 1
*  vec_A: 1*M2 = 2 
*  vec_B: 4*M2 = 8
*  mask: 1*M1 = 1
*  result: 1*M1 = 1
*  result aux 1*M1 = 1
*
*  Total: 22
*/
void velorisk_f32f32_matvec_rmajor_m2_reusage_vstore(float * A, float * B, float * C, int B_M, int B_N ){
 int gvl = vsetvl_e32m2(B_M);
vfloat32m1_t vec_0 = vfmv_v_f_f32m1(0, 4);
vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, 4);
for(int i = 0; i < B_N; i+=4){ //We generate 4 result at a time
        int j = 0;
        vfloat32m2_t vec_acc_0 = vfmv_v_f_f32m2(0, gvl);
        vfloat32m2_t vec_acc_1 = vfmv_v_f_f32m2(0, gvl);
        vfloat32m2_t vec_acc_2 = vfmv_v_f_f32m2(0, gvl);
        vfloat32m2_t vec_acc_3 = vfmv_v_f_f32m2(0, gvl);

        for(int k = 0; k < B_M/(gvl); k++){
            vfloat32m2_t vec_A_0 = vle32_v_f32m2(&A[j], gvl);
            vfloat32m2_t vec_B_0 = vle32_v_f32m2(&B[j], gvl);
            vfloat32m2_t vec_B_1 = vle32_v_f32m2(&B[j+i*B_M], gvl);
            vfloat32m2_t vec_B_2 = vle32_v_f32m2(&B[j+i*B_M*2], gvl);
            vfloat32m2_t vec_B_3 = vle32_v_f32m2(&B[j+i*B_M*3], gvl);
            vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_0, vec_B_0 , gvl);    
            vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_0, vec_B_1 , gvl);  
            vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_0, vec_B_2 , gvl);  
            vec_acc_3 = vfmacc_vv_f32m2(vec_acc_3, vec_A_0, vec_B_3 , gvl);
                        
            j += gvl+gvl+gvl;
        }
    vfloat32m1_t v_res_aux = vfredusum_vs_f32m2_f32m1(mask, vec_acc_0, vec_0, gvl);
    vfloat32m1_t v_res = vfadd_vv_f32m1(vec_0,v_res_aux,4);
    v_res_aux = vfredusum_vs_f32m2_f32m1(mask, vec_acc_1, vec_0, gvl);
    v_res = vslideup_vx_f32m1(v_res,v_res_aux,1,4);
    v_res_aux = vfredusum_vs_f32m2_f32m1(mask, vec_acc_2, vec_0, gvl);
    v_res = vslideup_vx_f32m1(v_res,v_res_aux,2,4);
    v_res_aux = vfredusum_vs_f32m2_f32m1(mask, vec_acc_3, vec_0, gvl);
    v_res = vslideup_vx_f32m1(v_res,v_res_aux,3,4); 
    vse32_v_f32m1( C+i, v_res,4);

    }
}



/////INT 8
/*
void velorisk_int8int8_matvec_rmajor_m4_unrolled(float * A, float * B, float * C, int B_M, int B_N ){
    vfloat32m1_t vec_0 = vfmv_v_f_f32m1(0, 4);
    vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, gvl);
    int gvl = vsetvl_e32m4(B_M);
    for(int i = 0; i < B_N; i++){ //We generate 1 result at a time
        int j = 0;
        vfloat32m4_t vec_acc = vfmv_v_f_f32m4(0, gvl);
        for(int k = 0; k < B_M/(gvl*3); k++){
            vfloat32m4_t vec_A_0 = vle32_v_f32m4(&A[j], gvl);
            vfloat32m4_t vec_A_1 = vle32_v_f32m4(&A[j+gvl], gvl);
            vfloat32m4_t vec_A_2 = vle32_v_f32m4(&A[j+gvl+gvl], gvl);
            vfloat32m4_t vec_B_0 = vle32_v_f32m4(&B[j], gvl);
            vfloat32m4_t vec_B_1 = vle32_v_f32m4(&B[j+gvl], gvl);
            vfloat32m4_t vec_B_2 = vle32_v_f32m4(&B[j+gvl+gvl], gvl);
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_0, vec_B_0 , gvl);    
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_1, vec_B_1 , gvl);  
            vec_acc = vfmacc_vv_f32m4(vec_acc, vec_A_2, vec_B_2 , gvl);              
            j += gvl+gvl+gvl;
        }
        vfloat32m1_t v_res = vfredusum_vs_f32m4_f32m1(mask, vec_acc, vec_0, gvl);
        C[i]= (float)vfmv_f_s_f32m1_f32(v_res);
    }
}



void velorisk_int8int8_matvec_rmajor_m2_reusage_vstore(int * A, float * B, float * C, int B_M, int B_N ){
 int gvl = vsetvl_e8m2(B_M);
vint8m1_t vec_0 = vmv_v_f_int8m1(0, 4);
vint8m1_t mask = vmv_v_f_int8m1(0xffff, 4);
for(int i = 0; i < B_N; i+=4){ //We generate 4 result at a time
        int j = 0;
        vint8m2_t vec_acc_0 = vfmv_v_f_f32m2(0, gvl);
        vint8m2_t vec_acc_1 = vfmv_v_f_f32m2(0, gvl);
        vint8m2_t vec_acc_2 = vfmv_v_f_f32m2(0, gvl);
        vint8m2_t vec_acc_3 = vfmv_v_f_f32m2(0, gvl);

        for(int k = 0; k < B_M/(gvl); k++){
            vint8m2_t vec_A_0 = vle32_v_i8m2(&A[j], gvl);
            vint8m2_t vec_B_0 = vle32_v_i8m2(&B[j], gvl);
            vint8m2_t vec_B_1 = vle32_v_i8m2(&B[j+i*B_M], gvl);
            vint8m2_t vec_B_2 = vle32_v_i8m2(&B[j+i*B_M*2], gvl);
            vint8m2_t vec_B_3 = vle32_v_i8m2(&B[j+i*B_M*3], gvl);
            vec_acc_0 = vmacc_vv_i8m2(vec_acc_0, vec_A_0, vec_B_0 , gvl);    
            vec_acc_1 = vmacc_vv_i8m2(vec_acc_1, vec_A_0, vec_B_1 , gvl);  
            vec_acc_2 = vmacc_vv_i8m2(vec_acc_2, vec_A_0, vec_B_2 , gvl);  
            vec_acc_3 = vmacc_vv_i8m2(vec_acc_3, vec_A_0, vec_B_3 , gvl);
                        
            j += gvl+gvl+gvl;
        }
    vint8m1_t v_res_aux = vredusum_vs_i8m2_i8m1(mask, vec_acc_0, vec_0, gvl);
    vint8m1_t v_res = vadd_vv_m1(vec_0,v_res_aux,4);

    v_res_aux = vredusum_vs_i8m2_i8m1(mask, vec_acc_1, vec_0, gvl);
    v_res = vslideup_vx_f32m1(v_res,v_res_aux,1,4);
    v_res_aux = vredusum_vs_i8m2_i8m1(mask, vec_acc_2, vec_0, gvl);
    v_res = vslideup_vx_i8m1(v_res,v_res_aux,2,4);
    v_res_aux = vredusum_vs_i8m2_i8m1(mask, vec_acc_3, vec_0, gvl);
    v_res = vslideup_vx_i8m1(v_res,v_res_aux,3,4); 

    vse32_v_m1( C+i, v_res,4); 

    }
}
*/
///////////// COLUMM MAJOR ///////////////////

/* Column-major implementation with strided load of B
*  Using The following number of Vector Regs
*  vec_acc: 1*M1= 1
*  vec_A: 1*M1 (Original)= 1, * 4 (number of FP32 in 1 vec reg) * M1 = 4 (We can reuse vec_A after gather) 
*  vec_B: 4*M1 = 4
*
*  Total: 9
*/

void velorisk_f32f32_matvec_cmajor_m1(float * A, float * B, float * C, int B_M, int B_N ){

//    printf("We made it to the matvec \n");
    int gvl = vsetvl_e32m1(B_N);
    for(int i = 0; i < B_N/gvl; i++){ //We generate gvl result at a time (4)
        int j = 0;
        //vfloat32m1_t vec_acc = vle32_v_f32m1(0, gvl);
         vfloat32m1_t vec_acc = vfmv_v_f_f32m1(0.0f, gvl);
//         printf("We made it to the matvec first load \n");
        for(int k = 0; k < B_M; k+=4){ //we need to unroll 4 times B as gvl for M1 is 4
//                printf("We made it to the inside loop  %d i iter \n", k);
                vfloat32m1_t vec_A = vle32_v_f32m1(A+j, gvl);
                vfloat32m1_t vec_B_0 = vle32_v_f32m1(B+B_N*k, gvl);
                vfloat32m1_t vec_B_1 = vle32_v_f32m1(B+B_N*k+B_N, gvl);
                vfloat32m1_t vec_B_2 = vle32_v_f32m1(B+B_N*k+B_N+B_N, gvl);
                vfloat32m1_t vec_B_3 = vle32_v_f32m1(B+B_N*k+B_N+B_N+B_N, gvl);

                vfloat32m1_t vec_A_0 = vrgather_vx_f32m1(vec_A, 0, gvl);
                vfloat32m1_t vec_A_1 = vrgather_vx_f32m1(vec_A, 1, gvl);
                vfloat32m1_t vec_A_2 = vrgather_vx_f32m1(vec_A, 2, gvl);
                vfloat32m1_t vec_A_3 = vrgather_vx_f32m1(vec_A, 3, gvl);


                vec_acc = vfmacc_vv_f32m1(vec_acc, vec_A_0, vec_B_0 , gvl);
                vec_acc = vfmacc_vv_f32m1(vec_acc, vec_A_1, vec_B_1 , gvl);    
                vec_acc = vfmacc_vv_f32m1(vec_acc, vec_A_2, vec_B_2 , gvl);    
                vec_acc = vfmacc_vv_f32m1(vec_acc, vec_A_3, vec_B_3 , gvl);              
                j += gvl;
        }
   //     printf("We made it to the %d i iter \n", i);
       vse32_v_f32m1( C+i*gvl, vec_acc,gvl);
  //       vse32_v_f32m1( C, vec_acc,gvl);
    }
}

/* Column-major implementation with strided load of B and M2
*  Using The following number of Vector Regs
*  vec_acc: 1*M2= 2
*  vec_A: 1*M2 (Original)= 2, * 4 (number of FP32 in 1 vec reg) * M2 = 16  BUT WE CAN REUSE AFTER USING THE GATTHER SO WE CAN JUST USE 8
*  vec_B: 8*M2 = 16
*
*  Total: 26  -> cant be done wihout reusing ( total :34 -> MAX 32)
*/
void velorisk_f32f32_matvec_cmajor_m2(float * A, float * B, float * C, int B_M, int B_N ){

        int gvl = vsetvl_e32m2(B_N);
        for(int i = 0; i < B_N/gvl; i++){ //We generate gvl result at a time
                int j = 0;
                vfloat32m2_t vec_acc = vfmv_v_f_f32m2(0.0f, gvl);
                
                for(int k = 0; k < B_M; k+=8){

                        vfloat32m2_t vec_A = vle32_v_f32m2(A+j, gvl);
                        vfloat32m2_t vec_B_0 = vle32_v_f32m2(B+B_N*k, gvl);
                        vfloat32m2_t vec_B_1 = vle32_v_f32m2(B+B_N*k+B_N, gvl);
                        vfloat32m2_t vec_B_2 = vle32_v_f32m2(B+B_N*k+B_N+B_N, gvl);
                        vfloat32m2_t vec_B_3 = vle32_v_f32m2(B+B_N*k+B_N+B_N+B_N, gvl);
                        vfloat32m2_t vec_B_4 = vle32_v_f32m2(B+B_N*k+B_N+B_N+B_N+B_N, gvl);
                        vfloat32m2_t vec_B_5 = vle32_v_f32m2(B+B_N*k+B_N+B_N+B_N+B_N+B_N, gvl);
                        vfloat32m2_t vec_B_6 = vle32_v_f32m2(B+B_N*k+B_N+B_N+B_N+B_N+B_N+B_N, gvl);
                        vfloat32m2_t vec_B_7 = vle32_v_f32m2(B+B_N+B_N*k+B_N+B_N+B_N+B_N+B_N, gvl);

                        
                        vfloat32m2_t vec_A_0 = vrgather_vx_f32m2(vec_A, 0,gvl);   
                        vfloat32m2_t vec_A_1 = vrgather_vx_f32m2(vec_A, 1,gvl);
                        vfloat32m2_t vec_A_2 = vrgather_vx_f32m2(vec_A, 2,gvl);
                        vfloat32m2_t vec_A_3 = vrgather_vx_f32m2(vec_A, 3,gvl);

                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_0, vec_B_0 , gvl);
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_1, vec_B_1 , gvl);   
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_2, vec_B_2 , gvl);   
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_3, vec_B_3 , gvl);

                        vec_A_0 = vrgather_vx_f32m2(vec_A, 4,gvl);   
                        vec_A_1 = vrgather_vx_f32m2(vec_A, 5,gvl);
                        vec_A_2 = vrgather_vx_f32m2(vec_A, 6,gvl);
                        vec_A_3 = vrgather_vx_f32m2(vec_A, 7,gvl);

                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_0, vec_B_4 , gvl);
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_1, vec_B_5 , gvl);   
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_2, vec_B_6 , gvl);   
                        vec_acc = vfmacc_vv_f32m2(vec_acc, vec_A_3, vec_B_7 , gvl);                      
                        

                        j += gvl;
                }
                vse32_v_f32m2(C+i*gvl, vec_acc,gvl);

        }
}


/*BROKEN DOESN'T WORK

*/

void velorisk_f32f32_matvec_cmajor_unrolled_m2(float * A, float * B, float * C, int B_M, int B_N ){

        int gvl = vsetvl_e32m2(B_N);
        for(int i = 0; i < B_N/(gvl*4); i++){ //We generate gvl * 4 result at a time
 //               int j = 0;
                vfloat32m2_t vec_acc_0 = vfmv_v_f_f32m2(0.0f, gvl);
                vfloat32m2_t vec_acc_1 = vfmv_v_f_f32m2(0.0f, gvl);
                vfloat32m2_t vec_acc_2 = vfmv_v_f_f32m2(0.0f, gvl);
                vfloat32m2_t vec_A = vfmv_v_f_f32m2(0.0f, gvl);

                for(int k = 0; k < B_M/(gvl*4); k++){
                        vec_A = vle32_v_f32m2(A+k*gvl, gvl);

                        vfloat32m2_t vec_B_0 = vle32_v_f32m2(B+k*gvl, gvl);
                        vfloat32m2_t vec_B_1 = vle32_v_f32m2(B+k*gvl+gvl, gvl);
                        vfloat32m2_t vec_B_2 = vle32_v_f32m2(B+k*gvl+gvl+gvl, gvl);
                        vfloat32m2_t vec_B_3 = vle32_v_f32m2(B+k*gvl+gvl+gvl+gvl, gvl);
                        
                        vfloat32m2_t vec_A_0 = vrgather_vx_f32m2(vec_A, 0,gvl);   
                        vfloat32m2_t vec_A_1 = vrgather_vx_f32m2(vec_A, 1,gvl);
                        vfloat32m2_t vec_A_2 = vrgather_vx_f32m2(vec_A, 2,gvl);
                        vfloat32m2_t vec_A_3 = vrgather_vx_f32m2(vec_A, 3,gvl);

                        vfloat32m2_t vec_A_4 = vrgather_vx_f32m2(vec_A, 4,gvl);   
                        vfloat32m2_t vec_A_5 = vrgather_vx_f32m2(vec_A, 5,gvl);
                        vfloat32m2_t vec_A_6 = vrgather_vx_f32m2(vec_A, 6,gvl);
                        vfloat32m2_t vec_A_7 = vrgather_vx_f32m2(vec_A, 7,gvl);


                        vec_A = vfmv_v_f_f32m2(0.0f, gvl);


                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_0, vec_B_0 , gvl);
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_1, vec_B_0 , gvl);   
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_2, vec_B_0 , gvl);   
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_3, vec_B_0 , gvl);                
                        
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_4, vec_B_0 , gvl);
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_5, vec_B_0 , gvl);   
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_6, vec_B_0 , gvl);   
                        vec_acc_0 = vfmacc_vv_f32m2(vec_acc_0, vec_A_7, vec_B_0 , gvl);    


                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_0, vec_B_1 , gvl);
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_1, vec_B_1 , gvl);   
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_2, vec_B_1 , gvl);   
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_3, vec_B_1 , gvl);                
                        
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_4, vec_B_1 , gvl);
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_5, vec_B_1 , gvl);   
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_6, vec_B_1 , gvl);   
                        vec_acc_1 = vfmacc_vv_f32m2(vec_acc_1, vec_A_7, vec_B_1 , gvl);    
                        

                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_0, vec_B_2 , gvl);
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_1, vec_B_2 , gvl);   
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_2, vec_B_2 , gvl);   
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_3, vec_B_2 , gvl);                
                        
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_4, vec_B_2 , gvl);
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_5, vec_B_2 , gvl);   
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_6, vec_B_2 , gvl);   
                        vec_acc_2 = vfmacc_vv_f32m2(vec_acc_2, vec_A_7, vec_B_2 , gvl);    


                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_0, vec_B_3 , gvl);
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_1, vec_B_3 , gvl);   
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_2, vec_B_3 , gvl);   
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_3, vec_B_3 , gvl);                
                        
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_4, vec_B_1 , gvl);
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_5, vec_B_1 , gvl);   
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_6, vec_B_1 , gvl);   
                        vec_A = vfmacc_vv_f32m2(vec_A, vec_A_7, vec_B_1 , gvl);    


 //                       j += gvl+gvl+gvl+gvl;
                }
                vse32_v_f32m2( C+i*gvl, vec_acc_0,gvl);
                vse32_v_f32m2( C+i*gvl+gvl, vec_acc_1,gvl);
                vse32_v_f32m2( C+i*gvl+gvl+gvl, vec_acc_2,gvl);
                vse32_v_f32m2( C+i*gvl+gvl+gvl+gvl, vec_A ,gvl);

        }
}

void velorisk_f32f32_matmat(float* mat_a, float* mat_b, float* mat_res, int a_transposed, int b_transposed,
                                    int a_width, int a_height, int b_height){
    // each thread manages n rows
    const int nth=1; const int ith=0;
    const int col_per_thread = b_height / nth;
    size_t vl = vsetvl_e32m1(a_width);
    const int vl_i_per_thread = a_width / vl / nth;
    // small implementation of SGEMM VELORISK, _per_thread variables are not tested
    // results not correct currently
    // parallelize by output columns, then by the vectors elements, using 4 vectors each time
    // results not optimal currently tho
    for(int col_=col_per_thread * ith;col_<(col_per_thread + col_per_thread*ith);col_++){
        for(int vl_i=vl_i_per_thread * ith;vl_i <(vl_i_per_thread + vl_i_per_thread * ith);vl_i+=4){
            int y_idx = col_ * a_width + vl_i * vl;
            vfloat32m1_t v_y = vle32_v_f32m1(mat_b + y_idx, vl);
            vfloat32m1_t v_y_2 = vle32_v_f32m1(mat_b + y_idx + vl, vl);
            vfloat32m1_t v_y_3 = vle32_v_f32m1(mat_b + y_idx + vl*2, vl);
            vfloat32m1_t v_y_4 = vle32_v_f32m1(mat_b + y_idx + vl*3, vl);
            
            for(int row_=0;row_<a_height;row_++){
                int x_idx = row_ * a_width + vl_i * vl;
                int out_idx = col_ * a_width + row_;
                vfloat32m1_t v_x = vle32_v_f32m1(((float*)mat_a) + x_idx, vl);
                vfloat32m1_t v_x_2 = vle32_v_f32m1(((float*)mat_a) + x_idx + vl, vl);
                vfloat32m1_t v_x_3 = vle32_v_f32m1(((float*)mat_a) + x_idx + vl*2, vl);
                vfloat32m1_t v_x_4 = vle32_v_f32m1(((float*)mat_a) + x_idx + vl*3, vl);
                
                vfloat32m1_t acc = vfmul_vv_f32m1(v_x, v_y, vl);
                acc = vfmacc_vv_f32m1(acc, v_x_2, v_y_2, vl);
                acc = vfmacc_vv_f32m1(acc, v_x_3, v_y_3, vl);
                acc = vfmacc_vv_f32m1(acc, v_x_4, v_y_4, vl);
                vfloat32m1_t mask = vfmv_v_f_f32m1(0xffffffff, vl);
                vfloat32m1_t zero_vec = vfmv_v_f_f32m1(0.0f, vl);
                vfloat32m1_t sum_reduced = vfredusum_vs_f32m1_f32m1(mask, acc, zero_vec, vl);
                mat_res[out_idx] += vfmv_f_s_f32m1_f32(sum_reduced);
            }
        }
    }
}

inline float ggml_compute_fp32_to_fp16_zfh( const float h) {
    float tmp;
    memcpy(&tmp, &h, sizeof(float));
    return (_Float16)tmp;
}

void quantize_row_q8_0_velorisk(const float * restrict x, block_q8_0_velo * restrict vy, int64_t k) {
    const int nb = k / QK8_0_vel;

    block_q8_0_velo * restrict y = vy;

    size_t vl = vsetvl_e32m4(QK8_0_vel);

    for (int i = 0; i < nb; i++) {
        // load elements
        vfloat32m4_t v_x   = vle32_v_f32m4(x+i*QK8_0_vel, vl);
		//vfloat32m4_t v_x   = __riscv_vle32_v_f32m4(x+i*QK8_0_vel, vl);
		

        vfloat32m4_t vfabs = vfabs_v_f32m4(v_x, vl);
        vfloat32m1_t tmp   = vfmv_v_f_f32m1(0.0f, vl);
        vfloat32m1_t vmax  = vfredmax_vs_f32m4_f32m1(vmax ,vfabs, tmp, vl);
        float amax = vfmv_f_s_f32m1_f32(vmax);

        const float d = amax / ((1 << 7) - 1);
        const float id = d ? 1.0f/d : 0.0f;

        y[i].d = ggml_compute_fp32_to_fp16_zfh(d);

        vfloat32m4_t x0 = vfmul_vf_f32m4(v_x, id, vl);

        // convert to integer
        vint16m2_t   vi = vfncvt_x_f_w_i16m2(x0, vl);
        vint8m1_t    vs = vncvt_x_x_w_i8m1(vi, vl);

        // store result
        vse8_v_i8m1(y[i].qs , vs, vl);
    }
}


void velorisk_f32f32(float* mat_a, float* mat_b, float* mat_res, int a_transposed, int b_transposed,
                                    int a_width, int a_height, int b_height){
    
    //printf("we are usinf Velorisk APR: %d\n", VELORISK_USE_API);

    #if     VELORISK_USE_API == 0
    for(int i=0;i<10;i++){}
    #elif   VELORISK_USE_API == 1
    // mat mat
    velorisk_f32f32_matmat(mat_a,mat_b,mat_res,a_transposed,b_transposed,a_width,a_height,b_height);
    #elif   VELORISK_USE_API == 2
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++) velorisk_f32f32_matvec_rmajor_m1(mat_b,mat_a,mat_res,a_width,a_height);
    //velorisk_f32f32_matvec_rmajor(mat_b,mat_a,mat_res,a_width,a_height); 
    #elif   VELORISK_USE_API == 3
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++) velorisk_f32f32_matvec_rmajor_m4_m1_unorder(mat_b,mat_a,mat_res,a_width,a_height);
    //velorisk_f32f32_matvec_rmajor(mat_b,mat_a,mat_res,a_width,a_height); 
        #elif   VELORISK_USE_API == 4
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++) velorisk_f32f32_matvec_rmajor_m4_m1_order(mat_b,mat_a,mat_res,a_width,a_height);
    //velorisk_f32f32_matvec_rmajor(mat_b,mat_a,mat_res,a_width,a_height); 
    #elif   VELORISK_USE_API == 5
    for(int b_h=0;b_h<b_height;b_h++) velorisk_f32f32_matvec_rmajor_m4_unrolled(mat_b,mat_a,mat_res,a_width,a_height );
    #elif   VELORISK_USE_API == 6
    for(int b_h=0;b_h<b_height;b_h++) velorisk_f32f32_matvec_rmajor_m2_reusage_vstore(mat_b,mat_a,mat_res,a_width,a_height );
    #elif   VELORISK_USE_API == 7
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++)   velorisk_f32f32_matvec_cmajor_m1(mat_b,mat_a,mat_res,a_width,a_height); 
    //velorisk_f32f32_matvec_cmajor_m1(mat_b,mat_a,mat_res,a_width,a_height);
    #elif   VELORISK_USE_API == 8
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++)   velorisk_f32f32_matvec_cmajor_m2(mat_b,mat_a,mat_res,a_width,a_height); 
    #elif   VELORISK_USE_API == 9
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++)   velorisk_f32f32_matvec_cmajor_unrolled_m2(mat_b,mat_a,mat_res,a_width,a_height);
    #elif   VELORISK_USE_API == 10
    // mat vec rmajor --> DONT CARE ABOUT A_TRANSPOSED AND B_TRANSPOSED NOW
    for(int b_h=0;b_h<b_height;b_h++)   velogpt_matvec_mult(mat_a,mat_b,mat_res,a_height,a_width);
    #endif
}
