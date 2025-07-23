/* VELORISK STUFF */
#include <velorisk.h>
#include <stdio.h>
//void kernel( int ne01, int nb01, const char* x_0_1, const char* x_0_0, const char* x_1_0,const char* x_1_1 , const char* y_0 , const char* y_1 , float* sumf_0, float* sumf_1, _Float16* x_00_d, _Float16* x_01_d, _Float16* x_10_d, _Float16* x_11_d, _Float16* y_0_d, _Float16* y_1_d){
int main(int argc, char** argv) {
    
    int8_t x00[64], x01[64], x10[64], x11[64], y0[32], y1[32];
    for(int i=0;i<64;i++){
        x00[i] = 1;
        x01[i] = 1;
        x10[i] = 1;
        x11[i] = 1;
        if(i<32){
            y0[i] = 1;
            y1[i] = 1;
        }
    }
    float sumf0, sumf1;
    for(int i=0;i<2;i++)   kernel(-1, -1, x00+i*32, x01+i*32, x10+i*32, x11+i*32, y0+i*16, y1+i*16, &sumf0, &sumf1, 1, 1, 1, 1, 1, 1);
    printf("sumf0 = %f, sumf1 = %f\n", sumf0, sumf1);
    return 0;
}