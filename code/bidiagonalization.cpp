// bidiagonalization.cpp
// 将 m×n 矩阵（本框架保证m ≥ n）通过 Householder 变换化为上双对角形
//
// 算法说明（你需要结合代码看）：
// 对上双对角化，需要交替从左侧和右侧应用 Householder 变换：
// 第 k 步（k = 0, 1, ..., n-1）：
//    - 从左侧作用 H_k，消去第 k 列中位置 (k+1,k), (k+2,k), ..., (m-1,k) 的元素
//    - 如果 k < n-2，从右侧作用 V_k，消去第 k 行中位置 (k,k+2), (k,k+3), ..., (k,n-1) 的元素
//
// 例如，对一个 4x4 矩阵 A，第一步 k=0：
//   - 从左侧作用 H_0，消去 A(1,0), A(2,0), A(3,0)，得到 B_0，同时更新 U = U * H_0
//   - 从右侧作用 V_0，消去 B_0(0,2)，B_0(0,3)，得到 B_1，同时更新 V = V * V_0
//
// 最终得到上双对角矩阵 B，只有主对角线和上次对角线有非零元素
//
// 本组件输出：A = U * B * V^T
// 其中 U（m×m）和 V（n×n）均为正交矩阵，B（m×n）为上双对角矩阵

#include "matrix.h"
#include <algorithm>
#include <chrono>
#include <cstddef>
#include <cmath>
#include <cstdio>
#include <stdexcept>
#include <vector>

#if defined(SVD_USE_HIP) && defined(__HIPCC__)
#include <hip/hip_runtime.h>
#define SVD_CUDA_ENABLED 1
#define cudaError_t hipError_t
#define cudaSuccess hipSuccess
#define cudaMalloc hipMalloc
#define cudaFree hipFree
#define cudaMemcpy hipMemcpy
#define cudaMemcpyHostToDevice hipMemcpyHostToDevice
#define cudaMemcpyDeviceToHost hipMemcpyDeviceToHost
#define cudaGetDeviceCount hipGetDeviceCount
#define cudaGetLastError hipGetLastError
#define cudaDeviceSynchronize hipDeviceSynchronize
#elif defined(SVD_USE_CUDA) && defined(__CUDACC__)
#include <cuda_runtime.h>
#define SVD_CUDA_ENABLED 1
#else
#define SVD_CUDA_ENABLED 0
#endif

#if !defined(SVD_DISABLE_SIMD) && defined(__AVX__)
#include <immintrin.h>
#elif !defined(SVD_DISABLE_SIMD) && defined(__SSE2__)
#include <emmintrin.h>
#elif !defined(SVD_DISABLE_SIMD) && defined(__aarch64__)
#include <arm_neon.h>
#endif

namespace
{

static double simd_sum_squares(const double *x, int len)
{
    int i = 0;
    double sum = 0.0;
#if !defined(SVD_DISABLE_SIMD) && defined(__AVX__)
    __m256d acc = _mm256_setzero_pd();
    for (; i + 4 <= len; i += 4)
    {
        __m256d a = _mm256_loadu_pd(x + i);
        acc = _mm256_add_pd(acc, _mm256_mul_pd(a, a));
    }
    double tmp[4];
    _mm256_storeu_pd(tmp, acc);
    sum = tmp[0] + tmp[1] + tmp[2] + tmp[3];
#elif !defined(SVD_DISABLE_SIMD) && defined(__SSE2__)
    __m128d acc = _mm_setzero_pd();
    for (; i + 2 <= len; i += 2)
    {
        __m128d a = _mm_loadu_pd(x + i);
        acc = _mm_add_pd(acc, _mm_mul_pd(a, a));
    }
    double tmp[2];
    _mm_storeu_pd(tmp, acc);
    sum = tmp[0] + tmp[1];
#elif !defined(SVD_DISABLE_SIMD) && defined(__aarch64__)
    float64x2_t acc = vdupq_n_f64(0.0);
    for (; i + 2 <= len; i += 2)
    {
        float64x2_t a = vld1q_f64(x + i);
        acc = vaddq_f64(acc, vmulq_f64(a, a));
    }
    double tmp[2];
    vst1q_f64(tmp, acc);
    sum = tmp[0] + tmp[1];
#endif
    for (; i < len; ++i)
    {
        sum += x[i] * x[i];
    }
    return sum;
}

static double simd_dot(const double *a, const double *b, int len)
{
    int i = 0;
    double sum = 0.0;
#if !defined(SVD_DISABLE_SIMD) && defined(__AVX__)
    __m256d acc = _mm256_setzero_pd();
    for (; i + 4 <= len; i += 4)
    {
        acc = _mm256_add_pd(acc, _mm256_mul_pd(_mm256_loadu_pd(a + i), _mm256_loadu_pd(b + i)));
    }
    double tmp[4];
    _mm256_storeu_pd(tmp, acc);
    sum = tmp[0] + tmp[1] + tmp[2] + tmp[3];
#elif !defined(SVD_DISABLE_SIMD) && defined(__SSE2__)
    __m128d acc = _mm_setzero_pd();
    for (; i + 2 <= len; i += 2)
    {
        acc = _mm_add_pd(acc, _mm_mul_pd(_mm_loadu_pd(a + i), _mm_loadu_pd(b + i)));
    }
    double tmp[2];
    _mm_storeu_pd(tmp, acc);
    sum = tmp[0] + tmp[1];
#elif !defined(SVD_DISABLE_SIMD) && defined(__aarch64__)
    float64x2_t acc = vdupq_n_f64(0.0);
    for (; i + 2 <= len; i += 2)
    {
        acc = vaddq_f64(acc, vmulq_f64(vld1q_f64(a + i), vld1q_f64(b + i)));
    }
    double tmp[2];
    vst1q_f64(tmp, acc);
    sum = tmp[0] + tmp[1];
#endif
    for (; i < len; ++i)
    {
        sum += a[i] * b[i];
    }
    return sum;
}

static void simd_add_scaled(double *dst, const double *src, double scale, int len)
{
    int i = 0;
#if !defined(SVD_DISABLE_SIMD) && defined(__AVX__)
    __m256d s = _mm256_set1_pd(scale);
    for (; i + 4 <= len; i += 4)
    {
        __m256d d = _mm256_loadu_pd(dst + i);
        __m256d x = _mm256_loadu_pd(src + i);
        _mm256_storeu_pd(dst + i, _mm256_add_pd(d, _mm256_mul_pd(s, x)));
    }
#elif !defined(SVD_DISABLE_SIMD) && defined(__SSE2__)
    __m128d s = _mm_set1_pd(scale);
    for (; i + 2 <= len; i += 2)
    {
        __m128d d = _mm_loadu_pd(dst + i);
        __m128d x = _mm_loadu_pd(src + i);
        _mm_storeu_pd(dst + i, _mm_add_pd(d, _mm_mul_pd(s, x)));
    }
#elif !defined(SVD_DISABLE_SIMD) && defined(__aarch64__)
    float64x2_t s = vdupq_n_f64(scale);
    for (; i + 2 <= len; i += 2)
    {
        float64x2_t d = vld1q_f64(dst + i);
        float64x2_t x = vld1q_f64(src + i);
        vst1q_f64(dst + i, vaddq_f64(d, vmulq_f64(s, x)));
    }
#endif
    for (; i < len; ++i)
    {
        dst[i] += scale * src[i];
    }
}

#if SVD_CUDA_ENABLED

struct DeviceBuffer
{
    explicit DeviceBuffer(std::size_t count) : count_(count)
    {
        if (count_ > 0 && cudaMalloc(&ptr_, count_ * sizeof(double)) != cudaSuccess)
            ptr_ = nullptr;
    }

    ~DeviceBuffer()
    {
        if (ptr_)
            cudaFree(ptr_);
    }

    DeviceBuffer(const DeviceBuffer &) = delete;
    DeviceBuffer &operator=(const DeviceBuffer &) = delete;

    double *get() { return ptr_; }
    const double *get() const { return ptr_; }
    std::size_t bytes() const { return count_ * sizeof(double); }
    bool ok() const { return count_ == 0 || ptr_ != nullptr; }

private:
    double *ptr_ = nullptr;
    std::size_t count_ = 0;
};

static bool cuda_ok(cudaError_t status)
{
    return status == cudaSuccess;
}

static bool cuda_device_ready()
{
    int count = 0;
    return cuda_ok(cudaGetDeviceCount(&count)) && count > 0;
}

#if defined(SVD_PROFILE_GPU)
struct GpuProfile
{
    double h2d_ms = 0.0;
    double d2h_ms = 0.0;
    double kernel_ms = 0.0;
    std::size_t h2d_bytes = 0;
    std::size_t d2h_bytes = 0;
    int left_calls = 0;
    int right_calls = 0;

    ~GpuProfile()
    {
        std::fprintf(stderr,
                     "[SVD_GPU_PROFILE] h2d_ms=%.3f d2h_ms=%.3f kernel_sync_ms=%.3f "
                     "h2d_MB=%.3f d2h_MB=%.3f left_calls=%d right_calls=%d\n",
                     h2d_ms, d2h_ms, kernel_ms,
                     static_cast<double>(h2d_bytes) / (1024.0 * 1024.0),
                     static_cast<double>(d2h_bytes) / (1024.0 * 1024.0),
                     left_calls, right_calls);
    }
};

static GpuProfile g_gpu_profile;

static double profile_now_ms()
{
    using clock = std::chrono::steady_clock;
    return std::chrono::duration<double, std::milli>(clock::now().time_since_epoch()).count();
}
#endif

__global__ void householder_dot_cols_kernel(const double *matrix, const double *v, double *out,
                                            int rows, int cols, int row0, int col0,
                                            int sub_rows, int sub_cols)
{
    extern __shared__ double partial[];
    const int col = blockIdx.x;
    const int tid = threadIdx.x;

    double sum = 0.0;
    if (col < sub_cols)
    {
        for (int i = tid; i < sub_rows; i += blockDim.x)
            sum += v[i] * matrix[(row0 + i) * cols + (col0 + col)];
    }
    partial[tid] = sum;
    __syncthreads();

    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1)
    {
        if (tid < stride)
            partial[tid] += partial[tid + stride];
        __syncthreads();
    }

    if (tid == 0 && col < sub_cols)
        out[col] = partial[0];
}

__global__ void householder_dot_rows_kernel(const double *matrix, const double *v, double *out,
                                            int rows, int cols, int row0, int col0,
                                            int sub_rows, int sub_cols)
{
    extern __shared__ double partial[];
    const int row = blockIdx.x;
    const int tid = threadIdx.x;

    double sum = 0.0;
    if (row < sub_rows)
    {
        for (int j = tid; j < sub_cols; j += blockDim.x)
            sum += matrix[(row0 + row) * cols + (col0 + j)] * v[j];
    }
    partial[tid] = sum;
    __syncthreads();

    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1)
    {
        if (tid < stride)
            partial[tid] += partial[tid + stride];
        __syncthreads();
    }

    if (tid == 0 && row < sub_rows)
        out[row] = partial[0];
}

__global__ void householder_left_update_kernel(double *matrix, const double *v, const double *w,
                                               double beta, int rows, int cols,
                                               int row0, int col0, int sub_rows, int sub_cols)
{
    const int col = blockIdx.x * blockDim.x + threadIdx.x;
    const int row = blockIdx.y * blockDim.y + threadIdx.y;
    if (row < sub_rows && col < sub_cols)
        matrix[(row0 + row) * cols + (col0 + col)] -= beta * v[row] * w[col];
}

__global__ void householder_rows_update_kernel(double *matrix, const double *v, const double *w,
                                               double beta, int rows, int cols,
                                               int row0, int col0, int sub_rows, int sub_cols)
{
    const int col = blockIdx.x * blockDim.x + threadIdx.x;
    const int row = blockIdx.y * blockDim.y + threadIdx.y;
    if (row < sub_rows && col < sub_cols)
        matrix[(row0 + row) * cols + (col0 + col)] -= beta * w[row] * v[col];
}

static bool copy_to_device(DeviceBuffer &dst, const double *src)
{
    if (!dst.ok())
        return false;
#if defined(SVD_PROFILE_GPU)
    const double t0 = profile_now_ms();
#endif
    const cudaError_t status = cudaMemcpy(dst.get(), src, dst.bytes(), cudaMemcpyHostToDevice);
#if defined(SVD_PROFILE_GPU)
    g_gpu_profile.h2d_ms += profile_now_ms() - t0;
    if (cuda_ok(status))
        g_gpu_profile.h2d_bytes += dst.bytes();
#endif
    return cuda_ok(status);
}

static bool copy_to_host(double *dst, const DeviceBuffer &src)
{
    if (!src.ok())
        return false;
#if defined(SVD_PROFILE_GPU)
    const double t0 = profile_now_ms();
#endif
    const cudaError_t status = cudaMemcpy(dst, src.get(), src.bytes(), cudaMemcpyDeviceToHost);
#if defined(SVD_PROFILE_GPU)
    g_gpu_profile.d2h_ms += profile_now_ms() - t0;
    if (cuda_ok(status))
        g_gpu_profile.d2h_bytes += src.bytes();
#endif
    return cuda_ok(status);
}

static bool gpu_householder_left(Matrix &B, Matrix &U, int k, const std::vector<double> &v, double beta)
{
    if (!cuda_device_ready())
        return false;

    const int m = B.rows();
    const int n = B.cols();
    const int sub_rows = m - k;
    const int sub_cols = n - k;
    const int threads = 256;
    const dim3 tile(16, 16);
    const dim3 b_grid((sub_cols + tile.x - 1) / tile.x, (sub_rows + tile.y - 1) / tile.y);
    const dim3 u_grid((sub_rows + tile.x - 1) / tile.x, (m + tile.y - 1) / tile.y);

    DeviceBuffer d_B(B.size()), d_U(U.size()), d_v(v.size()), d_wB(sub_cols), d_wU(m);
    if (!d_B.ok() || !d_U.ok() || !d_v.ok() || !d_wB.ok() || !d_wU.ok())
        return false;

    if (!copy_to_device(d_B, B.data()) || !copy_to_device(d_U, U.data()) ||
        !copy_to_device(d_v, v.data()))
        return false;

#if defined(SVD_PROFILE_GPU)
    const double kernel_t0 = profile_now_ms();
#endif
    householder_dot_cols_kernel<<<sub_cols, threads, threads * sizeof(double)>>>(d_B.get(), d_v.get(), d_wB.get(),
                                                                                 m, n, k, k, sub_rows, sub_cols);
    if (!cuda_ok(cudaGetLastError()))
        return false;
    householder_left_update_kernel<<<b_grid, tile>>>(d_B.get(), d_v.get(), d_wB.get(), beta,
                                                     m, n, k, k, sub_rows, sub_cols);
    if (!cuda_ok(cudaGetLastError()))
        return false;

    householder_dot_rows_kernel<<<m, threads, threads * sizeof(double)>>>(d_U.get(), d_v.get(), d_wU.get(),
                                                                          m, m, 0, k, m, sub_rows);
    if (!cuda_ok(cudaGetLastError()))
        return false;
    householder_rows_update_kernel<<<u_grid, tile>>>(d_U.get(), d_v.get(), d_wU.get(), beta,
                                                     m, m, 0, k, m, sub_rows);
    if (!cuda_ok(cudaGetLastError()) || !cuda_ok(cudaDeviceSynchronize()))
        return false;
#if defined(SVD_PROFILE_GPU)
    g_gpu_profile.kernel_ms += profile_now_ms() - kernel_t0;
    ++g_gpu_profile.left_calls;
#endif

    std::vector<double> host_B(B.size()), host_U(U.size());
    if (!copy_to_host(host_B.data(), d_B) || !copy_to_host(host_U.data(), d_U))
        return false;
    std::copy(host_B.begin(), host_B.end(), B.data());
    std::copy(host_U.begin(), host_U.end(), U.data());
    return true;
}

static bool gpu_householder_right(Matrix &B, Matrix &V, int k, const std::vector<double> &v, double beta)
{
    if (!cuda_device_ready())
        return false;

    const int m = B.rows();
    const int n = B.cols();
    const int sub_rows = m - k;
    const int sub_cols = n - k - 1;
    const int threads = 256;
    const dim3 tile(16, 16);
    const dim3 b_grid((sub_cols + tile.x - 1) / tile.x, (sub_rows + tile.y - 1) / tile.y);
    const dim3 v_grid((sub_cols + tile.x - 1) / tile.x, (n + tile.y - 1) / tile.y);

    DeviceBuffer d_B(B.size()), d_V(V.size()), d_vec(v.size()), d_wB(sub_rows), d_wV(n);
    if (!d_B.ok() || !d_V.ok() || !d_vec.ok() || !d_wB.ok() || !d_wV.ok())
        return false;

    if (!copy_to_device(d_B, B.data()) || !copy_to_device(d_V, V.data()) ||
        !copy_to_device(d_vec, v.data()))
        return false;

#if defined(SVD_PROFILE_GPU)
    const double kernel_t0 = profile_now_ms();
#endif
    householder_dot_rows_kernel<<<sub_rows, threads, threads * sizeof(double)>>>(d_B.get(), d_vec.get(), d_wB.get(),
                                                                                 m, n, k, k + 1, sub_rows, sub_cols);
    if (!cuda_ok(cudaGetLastError()))
        return false;
    householder_rows_update_kernel<<<b_grid, tile>>>(d_B.get(), d_vec.get(), d_wB.get(), beta,
                                                     m, n, k, k + 1, sub_rows, sub_cols);
    if (!cuda_ok(cudaGetLastError()))
        return false;

    householder_dot_rows_kernel<<<n, threads, threads * sizeof(double)>>>(d_V.get(), d_vec.get(), d_wV.get(),
                                                                          n, n, 0, k + 1, n, sub_cols);
    if (!cuda_ok(cudaGetLastError()))
        return false;
    householder_rows_update_kernel<<<v_grid, tile>>>(d_V.get(), d_vec.get(), d_wV.get(), beta,
                                                     n, n, 0, k + 1, n, sub_cols);
    if (!cuda_ok(cudaGetLastError()) || !cuda_ok(cudaDeviceSynchronize()))
        return false;
#if defined(SVD_PROFILE_GPU)
    g_gpu_profile.kernel_ms += profile_now_ms() - kernel_t0;
    ++g_gpu_profile.right_calls;
#endif

    std::vector<double> host_B(B.size()), host_V(V.size());
    if (!copy_to_host(host_B.data(), d_B) || !copy_to_host(host_V.data(), d_V))
        return false;
    std::copy(host_B.begin(), host_B.end(), B.data());
    std::copy(host_V.begin(), host_V.end(), V.data());
    return true;
}

#else

static bool gpu_householder_left(Matrix &, Matrix &, int, const std::vector<double> &, double)
{
    return false;
}

static bool gpu_householder_right(Matrix &, Matrix &, int, const std::vector<double> &, double)
{
    return false;
}

#endif

} // namespace

// 辅助函数，计算向量的范数（平方和开根）
static double vector_norm(const std::vector<double> &v)
{
    return std::sqrt(simd_sum_squares(v.data(), static_cast<int>(v.size())));
}

// 将 m×n 矩阵 A（m ≥ n）化为上双对角形，返回 B，同时输出 U（m×m）和 V（n×n）
Matrix to_bidiagonal(const Matrix &A, Matrix &U, Matrix &V)
{
    if (A.rows() < A.cols())
    {
        throw std::invalid_argument("to_bidiagonal: requires m >= n");
    }

    const int m = A.rows();
    const int n = A.cols();
    Matrix B = A;

    // U = I_m，V = I_n
    U = Matrix(m, m, 0.0);
    for (int i = 0; i < m; ++i)
        U.at(i, i) = 1.0;
    V = Matrix(n, n, 0.0);
    for (int i = 0; i < n; ++i)
        V.at(i, i) = 1.0;

    for (int k = 0; k < n; ++k)
    {
        // ================================================================
        // 步骤 1: 从左侧作用 Householder 变换，消去第 k 列中对角线以下的元素
        // ================================================================

        // 提取第 k 列从第 k 行往下的子向量
        // 例如：k=0 时提取 A(0:m-1, 0)，长度为 m-k+1 ; k=1 时提取 A(1:m-1, 1)
        std::vector<double> x(m - k);
        for (int i = 0; i < m - k; ++i)
        {
            x[i] = B.at(k + i, k);
        }

        double norm_x = vector_norm(x);

        if (norm_x > 1e-14 && k < m - 1)
        {
            // sign(x[0])：此处规定 x[0]==0 时取 +1
            double sigma = (x[0] >= 0.0 ? 1.0 : -1.0) * norm_x;

            // 实际上这里是+或者-都可以，手册里 Householder 一节是 -αe_1
            // 但我们这里 sigma 取了 sign(x[0]) * norm_x，所以是 +sigma * e_1 的形式
            std::vector<double> v(x);
            v[0] += sigma; // v = x + sigma * e_1

            // 计算 v^T v
            double vTv = simd_sum_squares(v.data(), static_cast<int>(v.size()));

            // SIMD实现：用simd_add_scaled完成Householder更新中的GER型逐行向量操作。
            if (vTv > 1e-28)
            {
                const double beta = 2.0 / vTv;

                // 手册里的 Householder 矩阵定义为 H = I - beta * v * v^T，其中 beta = 2 / (v^T v)
                // 从左侧作用 H：B_new = H * B_old = B_old - beta * v * (v^T * B_old)
                if (!gpu_householder_left(B, U, k, v, beta))
                {
                std::vector<double> w(n - k, 0.0);
                for (int i = 0; i < m - k; ++i)
                    simd_add_scaled(w.data(), B.row_data(k + i) + k, v[i], n - k);
                for (int i = 0; i < m - k; ++i)
                    simd_add_scaled(B.row_data(k + i) + k, w.data(), -beta * v[i], n - k);

                // 累积 U：U_new = U_old * H_k
                // U[:, k:m] -= beta * (U[:, k:m] * v) * v^T
                std::vector<double> wU(m, 0.0);
                for (int i = 0; i < m; ++i)
                    wU[i] = simd_dot(U.row_data(i) + k, v.data(), m - k);
                for (int i = 0; i < m; ++i)
                    simd_add_scaled(U.row_data(i) + k, v.data(), -beta * wU[i], m - k);
                }
            }
        }

        // 清除第 k 列中对角线以下的元素
        // 理论上应为 0，但不能完全保证全是 0，这里强制置零
        for (int i = k + 1; i < m; ++i)
        {
            B.at(i, k) = 0.0;
        }

        // ================================================================
        // 步骤 2: 从右侧作用 Householder 变换，消去第 k 行中 (k,k+2) 及右边的元素
        //        （只在 k < n-2 时需要）
        // ================================================================

        if (k < n - 2)
        {
            // 提取第 k 行从第 k+1 列往右的子向量（长度 n-k-1）
            std::vector<double> y(n - k - 1);
            for (int j = 0; j < n - k - 1; ++j)
            {
                y[j] = B.at(k, k + 1 + j);
            }

            // 与之前类似，计算模长
            double norm_y = vector_norm(y);

            if (norm_y > 1e-14)
            {
                double sigma = (y[0] >= 0.0 ? 1.0 : -1.0) * norm_y;

                // 构造 Householder 向量 v = y + sigma * e_1
                std::vector<double> v(y);
                v[0] += sigma;

                double vTv = simd_sum_squares(v.data(), static_cast<int>(v.size()));

                // SIMD实现：用simd_dot/simd_add_scaled完成右侧Householder的GEMV/GER型操作。
                if (vTv > 1e-28)
                {
                    const double beta = 2.0 / vTv;

                    // 注意：这里是从右侧作用 V_k
                    // B_new = B_old * V_k = B_old - beta * (B_old * v) * v^T
                    if (!gpu_householder_right(B, V, k, v, beta))
                    {
                    std::vector<double> w(m - k, 0.0);
                    for (int i = 0; i < m - k; ++i)
                        w[i] = simd_dot(B.row_data(k + i) + k + 1, v.data(), n - k - 1);
                    for (int i = 0; i < m - k; ++i)
                        simd_add_scaled(B.row_data(k + i) + k + 1, v.data(), -beta * w[i], n - k - 1);

                    // 累积 V：V_new = V_old * V_k
                    // V[:, k+1:n] -= beta * (V[:, k+1:n] * v) * v^T
                    std::vector<double> wV(n, 0.0);
                    for (int i = 0; i < n; ++i)
                        wV[i] = simd_dot(V.row_data(i) + k + 1, v.data(), n - k - 1);
                    for (int i = 0; i < n; ++i)
                        simd_add_scaled(V.row_data(i) + k + 1, v.data(), -beta * wV[i], n - k - 1);
                    }
                }
            }

            // 强制置零
            for (int j = k + 2; j < n; ++j)
            {
                B.at(k, j) = 0.0;
            }
        }
    }

    return B;
}
