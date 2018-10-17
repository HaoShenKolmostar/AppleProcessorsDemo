
kernel void matrixMultiplication(__global float* A, __global float* B, __global float* C,  int widthA, int widthB, int heightC )
{
    float sum = 0.0f;
    for(int i = 0;i < widthA; i++)
    {
        for(int j = 0; j < heightC; j++)
        {
            sum = 0;
            for(int k = 0; k < widthB; k++)
            {
                sum += A[i*widthB+k] * B[k*heightC+j];
            }
            C[i*heightC+j] = sum;
        }
    }
}

