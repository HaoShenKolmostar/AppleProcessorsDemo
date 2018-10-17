#ifndef matrixmul_h
#define matrixmul_h

#include "stdio.h"
#include "stdlib.h"
#include "time.h"
#include <OpenCL/opencl.h>
#define MEM_SIZE (128)
#define MAX_SOURCE_SIZE (0x100000)

double gmatrix(uint32_t widthA, uint32_t heightA,uint32_t heightB);


#endif /* matrixmul_h */
