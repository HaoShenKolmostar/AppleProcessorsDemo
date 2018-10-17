#include "matrixmul.h"

double gmatrix(uint32_t widthA, uint32_t heightA,uint32_t heightB){
    int widthB = heightA;
    int widthC = widthA;
    int heightC = heightB;
    float *A = (float *)malloc(sizeof(float) * widthA * heightA);
    float *B = (float *)malloc(sizeof(float) * widthB * heightB);
    float *Res = (float *)malloc(sizeof(float) * widthC * heightC);
    cl_device_id device_id = NULL;
    cl_context context = NULL;
    cl_command_queue command_queue = NULL;
    cl_mem memobjA = NULL;
    cl_mem memobjB = NULL;
    cl_mem memobjC = NULL;
    cl_mem rowA = NULL;
    cl_mem rowB = NULL;
    cl_mem colC = NULL;
    cl_program program = NULL;
    cl_kernel kernel = NULL;
    cl_platform_id platform_id = NULL;
    cl_uint ret_num_devices;
    cl_uint ret_num_platforms;
    cl_int ret;
    
    int row = widthA;
    int col = heightC;
    int rowb = widthB;
    for (int i = 0; i < widthA; i++)
    {
        for (int j = 0; j < heightA; j++)
        {
            *((A + i * heightA + j)) = j % 3 + 1;
        }
    }
    for (int i = 0; i < widthB; i++)
    {
        for (int j = 0; j < heightB; j++)
        {
            *((B + i * heightB + j)) = j % 3 + 1;
        }
    }
    
    char *source_str = "kernel void matrixMultiplication(__global float* A, __global float* B, __global float* C,  int widthA, int widthB, int heightC ){float sum = 0.0f;for(int i = 0;i < widthA; i++){for(int j = 0; j < heightC; j++){sum = 0;for(int k = 0; k < widthB; k++){sum += A[i*widthB+k] * B[k*heightC+j];}C[i*heightC+j] = sum;}}}";
    
    size_t source_size = strlen(source_str);
    
    /* Get Platform and Device Info */
    ret = clGetPlatformIDs(1, &platform_id, &ret_num_platforms);
    ret = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_GPU, 1, &device_id, &ret_num_devices);
    
    /* Create OpenCL context */
    context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &ret);
    
    /* Create Command Queue */
    command_queue = clCreateCommandQueue(context, device_id, 0, &ret);
    
    /* Create Memory Buffer */
    memobjA = clCreateBuffer(context, CL_MEM_READ_WRITE, widthA * heightA * sizeof(float), NULL, &ret);
    memobjB = clCreateBuffer(context, CL_MEM_READ_WRITE, widthB * heightB * sizeof(float), NULL, &ret);
    memobjC = clCreateBuffer(context, CL_MEM_READ_WRITE, widthC * heightC * sizeof(float), NULL, &ret);
    rowA = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(int), NULL, &ret);
    rowB = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(int), NULL, &ret);
    colC = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(int), NULL, &ret);
    
    // Copy the lists A and B to their respective memory buffers
    ret = clEnqueueWriteBuffer(command_queue, memobjA, CL_TRUE, 0,
                               widthA * heightA * sizeof(int), A, 0, NULL, NULL);
    ret = clEnqueueWriteBuffer(command_queue, memobjB, CL_TRUE, 0,
                               widthB * heightB * sizeof(int), B, 0, NULL, NULL);
    ret = clEnqueueWriteBuffer(command_queue, rowA, CL_TRUE, 0, sizeof(int), &row, 0, NULL, NULL);
    ret = clEnqueueWriteBuffer(command_queue, rowB, CL_TRUE, 0, sizeof(int), &rowb, 0, NULL, NULL);
    ret = clEnqueueWriteBuffer(command_queue, colC, CL_TRUE, 0, sizeof(int), &col, 0, NULL, NULL);

    /* Create Kernel Program from the source */
    program = clCreateProgramWithSource(context, 1, (const char **)&source_str,
                                        (const size_t *)&source_size, &ret);
    
    /* Build Kernel Program */
    ret = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
    
    /* Create OpenCL Kernel */
    kernel = clCreateKernel(program, "matrixMultiplication", &ret);
    
    
    
    /* Set OpenCL Kernel Arguments */
    ret = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&memobjA);
    ret = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&memobjB);
    ret = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&memobjC);
    ret = clSetKernelArg(kernel, 3, sizeof(int), (void *)&row);
    ret = clSetKernelArg(kernel, 4, sizeof(int), (void *)&rowb);
    ret = clSetKernelArg(kernel, 5, sizeof(int), (void *)&col);
    /* Execute OpenCL Kernel */
    size_t globalThreads[2] = {widthA, heightB};
    size_t localThreads[2] = {1, 1};
    
    clock_t begin = clock();
    
    clEnqueueNDRangeKernel(command_queue, kernel, 2, NULL, globalThreads, localThreads, NULL, 0, NULL);
    /* Copy results from the memory buffer */
    ret = clEnqueueReadBuffer(command_queue, memobjC, CL_TRUE, 0,
                              widthA * heightC * sizeof(float), Res, 0, NULL, NULL);
    
    clock_t end = clock();
    
    ret = clFlush(command_queue);
    ret = clFinish(command_queue);
    ret = clReleaseKernel(kernel);
    ret = clReleaseProgram(program);
    ret = clReleaseMemObject(memobjA);
    ret = clReleaseMemObject(memobjB);
    ret = clReleaseMemObject(memobjC);
    ret = clReleaseCommandQueue(command_queue);
    ret = clReleaseContext(context);
    
    double runtime = (double)(end - begin) / CLOCKS_PER_SEC;
    return runtime;
}
