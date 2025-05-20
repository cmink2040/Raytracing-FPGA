#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>
#include <cublas_v2.h>

#define CHECK_CUDA(call)                                                          \
  do {                                                                             \
    cudaError_t err = (call);                                                      \
    if (err != cudaSuccess) {                                                      \
      fprintf(stderr, "CUDA error %s:%d: %s\n", __FILE__, __LINE__,                \
              cudaGetErrorString(err));                                           \
      std::exit(1);                                                                \
    }                                                                              \
  } while (0)

#define CHECK_CUBLAS(call)                                                        \
  do {                                                                             \
    cublasStatus_t st = (call);                                                    \
    if (st != CUBLAS_STATUS_SUCCESS) {                                             \
      fprintf(stderr, "cuBLAS error %s:%d: %d\n", __FILE__, __LINE__, st);         \
      std::exit(2);                                                                \
    }                                                                              \
  } while (0)

int main(int argc, char** argv) {
  // parse args: N, timed_iters, warmup_iters
  int N           = (argc>1 ? std::atoi(argv[1]) : 65536);
  int timedIters  = (argc>2 ? std::atoi(argv[2]) : 80);
  int warmupIters = (argc>3 ? std::atoi(argv[3]) : 50);

  size_t bytesA = size_t(N)*N * sizeof(int8_t);
  size_t bytesC = size_t(N)*N * sizeof(int32_t);

  // allocate device matrices
  int8_t  *d_A, *d_B;
  int32_t *d_C;
  CHECK_CUDA(cudaMalloc(&d_A, bytesA));
  CHECK_CUDA(cudaMalloc(&d_B, bytesA));
  CHECK_CUDA(cudaMalloc(&d_C, bytesC));

  // cuBLAS handle + Tensor-Core mode
  cublasHandle_t handle;
  CHECK_CUBLAS(cublasCreate(&handle));
  CHECK_CUBLAS(cublasSetMathMode(handle, CUBLAS_TENSOR_OP_MATH));
  cublasSetMathMode(handle, CUBLAS_TENSOR_OP_MATH);


  const int32_t alpha = 1, beta = 0;

  // -- WARM-UP LOOPS --
  for (int i = 0; i < warmupIters; ++i) {
    CHECK_CUBLAS(cublasGemmEx(handle,
      CUBLAS_OP_N, CUBLAS_OP_N,
      N, N, N,
      &alpha,
      d_A, CUDA_R_8I, N,
      d_B, CUDA_R_8I, N,
      &beta,
      d_C, CUDA_R_32I, N,
      CUDA_R_32I,
      CUBLAS_GEMM_DFALT_TENSOR_OP));
  }

  // setup timing
  cudaEvent_t start, stop;
  CHECK_CUDA(cudaEventCreate(&start));
  CHECK_CUDA(cudaEventCreate(&stop));

  CHECK_CUDA(cudaEventRecord(start, nullptr));
  for (int i = 0; i < timedIters; ++i) {
    CHECK_CUBLAS(cublasGemmEx(handle,
      CUBLAS_OP_N, CUBLAS_OP_N,
      N, N, N,
      &alpha,
      d_A, CUDA_R_8I, N,
      d_B, CUDA_R_8I, N,
      &beta,
      d_C, CUDA_R_32I, N,
      CUDA_R_32I,
      CUBLAS_GEMM_DFALT_TENSOR_OP));
  }
  CHECK_CUDA(cudaEventRecord(stop, nullptr));
  CHECK_CUDA(cudaEventSynchronize(stop));

  float ms = 0;
  CHECK_CUDA(cudaEventElapsedTime(&ms, start, stop));

  double secs   = ms/1000.0;
  double ops    = double(2ULL)*N*N*N*timedIters;
  double tops   = ops / secs / 1e12;

  printf("Matrix: %d×%d, Warm-ups: %d, Timed iters: %d\n",
         N, N, warmupIters, timedIters);
  printf("Elapsed: %.3f ms → %.2f TOPS (INT8)\n", ms, tops);

  // cleanup
  cublasDestroy(handle);
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
  return 0;
}
