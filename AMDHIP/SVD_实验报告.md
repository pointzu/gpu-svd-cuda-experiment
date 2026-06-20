# 并行程序设计学习与 SVD 选题报告

## 1. 报告范围

本报告整理两部分内容：

1. AMD HIP notebook 中需要体现学习通过的主要代码填空和分析填空。GPU 型号、Compute Units 这类简单运行环境信息不放入正文。
2. SVD 选题的服务器代码实现思路、验证方式和运行结果记录。

本地路径：

- HIP notebooks: `C:\Users\pointzu\Desktop\大二下\并行程序设计\GPU\AMDHIP`
- SVD 服务器代码拷贝: `C:\Users\pointzu\Desktop\大二下\并行程序设计\GPU\code`

## 2. AMD HIP notebook 填空汇总

### 2.1 Lab1 Vector Add

核心线程索引公式如下：

```cpp
int idx = blockIdx.x * blockDim.x + threadIdx.x;
if (idx < N) {
    C[idx] = A[idx] + B[idx];
}
```

对于 `N = 1000` 的 launch 配置，多个 block size 都会分配到 1024 个总线程，因此线程利用率为：

```text
1000 / 1024 = 97.66%
```

这并不表示性能完全相同，因为实际性能还受 wavefront 对齐、occupancy、调度开销、寄存器/共享内存压力和全局内存带宽影响。实测中 block size 512 的平均时间最低，为 `0.1382 ms`。

Grid-stride loop 的步长为：

```cpp
int stride = gridDim.x * blockDim.x;
```

该写法让固定数量的线程覆盖任意大小的数组，同时保持相邻线程的访存连续性。Sub-wavefront 实验中，block size 8 的平均时间为 `0.1749 ms`，明显慢于 wave32 对齐的 block size 32 (`0.1405 ms`)，说明过小 block 会浪费 wavefront lane。

### 2.2 Lab2 Matrix Transpose

转置输出矩阵大小为 `cols x rows`，所以输出线性下标必须使用输出行长度 `rows`：

```cpp
output[idx * rows + idy] = input[idy * cols + idx];
```

如果误写成 `idx * cols + idy`，非方阵时会把输出位置映射错。

实测 kernel time：

| Test | Dimensions | Elements | Time |
|---|---:|---:|---:|
| 1 | 16 x 16 | 256 | 0.0077 ms |
| 2 | 128 x 32 | 4,096 | 0.0108 ms |
| 3 | 1 x 1024 | 1,024 | 0.0087 ms |
| 4 | 1001 x 2001 | 2,003,001 | 0.2352 ms |

Test 4 元素数约为 Test 2 的 `489x`，但时间约为 `21.8x`，原因是小规模测试受 kernel launch、调度和低 occupancy 固定开销影响明显；大规模测试能摊薄固定开销，但 naive transpose 仍然存在 strided write，导致非合并写事务。

访存分析：

- Read: `input[idy * cols + idx]`，相邻线程读连续地址，是 coalesced access。
- Write: `output[idx * rows + idy]`，相邻线程写入地址间隔为 `rows` 个 float。若 `rows = 1024`，stride 为 `4096 bytes`。
- 32 个线程写 strided 地址时，需要约 32 个 memory transactions。
- Tiled transpose 中共享内存 tile 使用 `+1` padding，把 pitch 从 32 改为 33，可以避免转置访问时的 shared memory bank conflict。

### 2.3 Lab3 Histogram

Naive GPU histogram 的问题是每个 bin 对整个输入数组扫描一次，因此全局内存读次数为：

```text
N * num_bins
```

优化版本使用 shared memory histogram。每个 block 先在共享内存中统计，再把每个 bin 的 block 局部结果用 global atomic 加回全局 histogram。这样全局 atomic 数量从“每个元素一次”降为“每个 block 每个 bin 一次”。

实测性能：

| Implementation | Test 2 | Test 4 |
|---|---:|---:|
| Serial CPU | 2.3624 ms | 22.6050 ms |
| Naive GPU | 23.2188 ms | 2526.8180 ms |
| Optimized GPU | 0.4661 ms | 4.4517 ms |

Speedup：

- Optimized vs Serial: Test 2 和 Test 4 都约 `5.1x`。
- Optimized vs Naive: Test 2 为 `49.8x`，Test 4 为 `567.6x`。

内存流量降低比例为 `num_bins`。例如 256 bins 时，优化版本将输入全局内存读取减少约 `256x`。

### 2.4 Lab4 Reduction

Tree reduction 对 256 个元素进行块内归约，需要：

```text
log2(256) = 8 steps
```

若 `N = 1024` 且 block size 为 256，则需要 `ceil(1024 / 256) = 4` 个 block，每个 block 输出一个 partial sum。

Occupancy sweep 中所有测试 block size 都达到 100% occupancy，但执行时间不同：

| Block Size | Warps/Block | Occupancy | Time |
|---:|---:|---:|---:|
| 64 | 2 | 100.00% | 0.0737 ms |
| 128 | 4 | 100.00% | 0.0664 ms |
| 256 | 8 | 100.00% | 0.0641 ms |
| 512 | 16 | 100.00% | 0.0694 ms |
| 1024 | 32 | 100.00% | 0.0668 ms |

结论：high occupancy 不等于最高性能。Block size 256 最快，说明同步次数、最终 atomic 数量、共享内存访问和调度粒度都会影响性能。

四种 reduction 策略对比：

| Strategy | Time | Result |
|---|---:|---:|
| Naive Atomic | 0.0856 ms | -74,993,790 |
| Tree Shared Memory | 0.0628 ms | -74,993,790 |
| Tree + Warp Shuffle | 0.0588 ms | -74,993,790 |
| Multi-Element + Tree + Shuffle | 0.0478 ms | -74,993,790 |

最快的是 multi-element + tree + shuffle，相比 naive atomic 约 `1.79x`。

### 2.5 Lab5 Monte Carlo Integration

Atomic 版本中每个线程计算：

```cpp
tmp = (b - a) * y_samples[idx] / n_samples;
atomicAdd(result, tmp);
```

这种写法总工作量是 `O(n_samples)`，但所有线程争用同一个全局地址，atomic accumulation 会成为瓶颈。

Test 1 手算：

```text
sum_y = 4.1805 + 1.7864 + 4.7554 + 3.9983 + 2.2786 + 1.1873 + 4.1222 + 1.4420
      = 23.7507
result = (2 / 8) * 23.7507 = 5.937675
```

性能记录：

| Test | Sample Count | Execution Time |
|---|---:|---:|
| 4 | 100,000 | real 0m0.074s |
| 7 | 10,000,000 | real 0m0.878s |
| 8 | 100,000,000 | real 0m8.425s |

从 Test 4 到 Test 7，样本数增加 `100x`，运行时间增加：

```text
0.878 / 0.074 = 11.86x
```

并非严格线性，因为小输入包含内存分配、H2D/D2H、kernel launch 和同步等固定开销。大输入则越来越受内存流量和 global atomic contention 限制。

Shared-memory reduction 的优化思路：每个 block 先把多个 sample 累加到 shared memory，再做块内 tree reduction，最后只由 thread 0 进行一次 global `atomicAdd`。对于 `N = 1,000,000`、256 threads/block，block 数为 `ceil(1,000,000 / 256) = 3907`，global atomic 从 `1,000,000` 次降为 `3907` 次。

### 2.6 Lab6 K-Means

Assignment kernel 中，每个点需要和所有 centroid 计算距离，所以每个线程的复杂度为：

```text
O(k)
```

当 `k = 100` 时，每个线程进行 100 次距离比较。

Update kernel 使用 shared memory atomics 先在 block 内聚合，再写回 global memory。这样可以减少慢速 global atomic 的数量，并降低全局内存争用。

若某个 centroid 没有分配到点，程序保留它的旧位置，避免除以 0 或产生无效 centroid。

Test 4 执行时间：

```text
real 0m0.085s
```

主导开销是 assignment step，因为每个点都要计算到每个 centroid 的距离，复杂度为 `O(N * k)`。Update step 是 `O(N + k)`，当 `k` 较大时通常不是最主要瓶颈。

Centroid 访存优化可以把 centroid 放入 shared memory、constant memory 或只读 cache 中复用，避免每个线程反复从 global memory 读取同一批 centroid。收敛判断阈值为：

```cpp
dx * dx + dy * dy < 1.0e-8
```

Double buffering 让旧 centroid 和新 centroid 分开存储，既能安全比较收敛，也避免在当前迭代中覆盖仍需使用的数据。

## 3. SVD 选题实现说明

### 3.1 计算流程

SVD 框架的主流程为：

1. `main.cpp` 构造测试矩阵 `A`。
2. `to_bidiagonal` 将 `A` 化为上二对角矩阵 `B`，并累计正交矩阵 `U`、`V`，保持 `A = U * B * V^T`。
3. `gkh_svd_from_bidiagonal` 对上二对角矩阵做 Golub-Kahan 迭代，使 `B` 收敛为非负降序对角矩阵。
4. 主程序验证重构误差、正交误差、对角结构和奇异值排序。

根据 README 约束，不修改 `main.cpp`、`test.sh`、`qsub.sh`。本次只在允许的算法实现文件中确认和整理 SVD 优化点。

### 3.2 上二对角化优化

`bidiagonalization.cpp` 中的 Householder 更新包含 GEMV/GER 型操作：

- `w = v^T * Bsub`
- `Bsub = Bsub - beta * v * w^T`
- 对 `U`、`V` 的累积更新也有类似向量点积与向量加权更新。

代码中实现了三个 SIMD helper：

- `simd_sum_squares`: 向量平方和，用于 norm 和 `v^T v`。
- `simd_dot`: 点积，用于 GEMV 型中间量。
- `simd_add_scaled`: `dst += scale * src`，用于 GER 型逐行更新。

这些 helper 根据编译平台自动选择 AVX、SSE2 或 AArch64 NEON，其他尾部元素走标量循环。这样可以在不改 `main.cpp` 的前提下，加速 Householder 的热点内层循环。

### 3.3 GKH 迭代并行化

`gkh.cpp` 的优化重点是对已解耦的 active blocks 并行执行 bulge chasing：

- `split_active_blocks` 根据超对角线是否收敛为 0，把上二对角矩阵拆成多个独立子块。
- `collect_nontrivial_blocks` 收集仍需迭代的子块。
- `PthreadBlockPool` 使用 pthread 风格工作队列分发独立 block。
- `process_blocks_openmp` 在支持 OpenMP 时使用 dynamic schedule。
- MPI 路径中 root rank 分发 block，worker rank 计算后回传对应的 `B/U/V` 子结果。

运行模式由环境变量控制：

```bash
SVD_MODE=serial   # 串行
SVD_MODE=pthread  # 默认非 MPI 路径
SVD_MODE=openmp   # 需要 -fopenmp 编译
SVD_MODE=mpi      # 需要 MPI 编译和 SVD_USE_MPI
SVD_THREADS=4
```

注意：不同 block 必须互不依赖时才适合并行，单个 block 内的 Givens rotation 仍需要保持顺序。

### 3.4 本地验证结果

本地 Windows 环境只用于 smoke test，不替代 OpenEuler 服务器提交结果。使用命令：

```bash
g++ -std=c++17 -O2 -pthread -I ..\code ..\code\main.cpp ..\code\bidiagonalization.cpp ..\code\gkh.cpp -o .\svd_check.exe
.\svd_check.exe 20260410
```

结果：5 个测试全部 PASS，包括 1000 x 1000 随机矩阵。

本地一次运行的汇总：

| Metric | Value |
|---|---:|
| Total bidiagonalization time | 2053.41 ms |
| Total GKH iteration time | 4329.61 ms |
| Passed cases | 5 / 5 |

已有服务器 `O2_4cores` 输出中也显示 5 / 5 PASS：

| Metric | Value |
|---|---:|
| Total bidiagonalization time | 3456.61 ms |
| Total GKH iteration time | 23968.4 ms |
| Passed cases | 5 / 5 |

最终提交仍应以服务器上重新运行 `test.sh` 后产生的 `test.o` 为准。

## 4. 结论

HIP notebooks 的主要代码和分析填空已经整理进报告。SVD 选题方面，当前代码遵守框架约束，不改 `main.cpp/test.sh/qsub.sh`，在上二对角化的 Householder 热点中使用 SIMD helper，并在 GKH 阶段支持 block 级 pthread/OpenMP/MPI 并行。正确性验证通过 5 个测试样例，服务器提交时需要使用 `test.sh` 重新收集正式结果。
