#include <string.h>

float ggml_compute_fp16_to_fp32(_Float16 h) {
    _Float16 tmp;
    memcpy(&tmp, &h, sizeof(_Float16));
    return (float)tmp;
}