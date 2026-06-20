# SVD 选题最终服务器运行指导

## 1. 对实验要求的检查结论

当前 `bidiagonalization.cpp` 已经把 `to_bidiagonal` 内部的 Householder 更新接入 GPU 路径：

- 左乘 Householder：
  - `w = v^T * Bsub`
  - `Bsub = Bsub - beta * v * w^T`
  - `U[:, k:m] = U[:, k:m] - beta * (U[:, k:m] * v) * v^T`
- 右乘 Householder：
  - `w = Bsub * v`
  - `Bsub = Bsub - beta * w * v^T`
  - `V[:, k+1:n] = V[:, k+1:n] - beta * (V[:, k+1:n] * v) * v^T`

代码中已实现手写 CUDA/HIP kernel：

- `householder_dot_cols_kernel`
- `householder_dot_rows_kernel`
- `householder_left_update_kernel`
- `householder_rows_update_kernel`

这对应指导书 5.2.2 的“手写 CUDA kernel”。当前版本没有实现 cuBLAS 分支，因此报告中不要写“已经使用 cuBLAS”。可以写：

> 本实验选择手写 CUDA kernel 完成 GEMV/GER 型 Householder 更新。由于 `Matrix` 类采用行主序，而 cuBLAS 默认列主序，直接替换容易导致转置关系错误；本实现保留行主序布局，并在 kernel 中显式按行主序访问矩阵。与 cuBLAS 相比，手写 kernel 更容易贴合框架存储格式，但缺少库函数在访存、分块和规约上的高度优化。

如果老师严格要求 cuBLAS 对比，可补充说明“本实验主要完成手写 kernel 路径，cuBLAS 留作对比讨论”。一般按指导书“CUDA（或 cuBLAS）”的表述，手写 CUDA kernel 是可接受路线。

## 2. 推荐保留的正式结果

你已经跑出的结果可作为正式正确性结果：

- 命令：

```bash
nvcc -std=c++17 -O2 -DSVD_USE_CUDA -x cu main.cpp bidiagonalization.cpp gkh.cpp -o main
./main 2412592
```

- 结果：
  - 随机种子基值：`2412592`
  - 通过：`5 / 5`
  - `1000x1000` 上二对角化耗时：`4090.56 ms`
  - `1000x1000` GKH 迭代耗时：`32691.9 ms`
  - 总上二对角化耗时：`4090.62 ms`
  - 总 GKH 迭代耗时：`32695.4 ms`

报告结论可以写：

> 程序在 5 个测试样例上全部通过，说明 GPU 化后的 Householder 上二对角化没有破坏 SVD 分解正确性。大规模 `1000x1000` 样例中，GKH 迭代耗时明显高于上二对角化，说明整体 SVD 流程仍主要受后续 CPU 侧迭代阶段限制。

## 3. 必跑：CPU 基线与手写 CUDA 对比

为了体现“对比加速效果”，建议至少跑 CPU 基线和 CUDA kernel 两组。

如果服务器提示：

```bash
bash: nvcc: command not found
```

说明当前环境没有加载 NVIDIA CUDA 编译器，或者这台机器本身不是 NVIDIA CUDA 环境。此时先不要卡在 `nvcc`，按下面顺序检查：

```bash
which nvcc
which hipcc
module avail 2>&1 | grep -Ei 'cuda|hip|rocm'
```

若 `hipcc` 存在，直接使用本代码已经支持的 HIP 路径：

```bash
hipcc -std=c++17 -O2 -pthread -DSVD_USE_HIP bidiagonalization.cpp gkh.cpp main.cpp -o main_hip
./main_hip 2412592 2>&1 | tee result_hip_O2.txt
```

若 `module avail` 中能看到 CUDA，例如 `cuda/xx.x`，则先加载模块：

```bash
module load cuda
which nvcc
nvcc --version
```

再运行 CUDA 编译命令。若 `nvcc` 和 `hipcc` 都不存在，先用 CPU 基线完成正确性和 `perf`，并联系助教确认 GPU 编译环境所在节点或模块名称。

### 3.1 CPU/SIMD 基线

```bash
g++ -std=c++17 -O2 -pthread main.cpp bidiagonalization.cpp gkh.cpp -o main_cpu
./main_cpu 2412592 2>&1 | tee result_cpu_O2.txt
```

截图：

- 编译命令
- `通过: 5 / 5`
- `总上二对角化耗时(ms)`
- `总GKH迭代耗时(ms)`

### 3.2 手写 CUDA kernel

```bash
nvcc -std=c++17 -O2 -DSVD_USE_CUDA -x cu main.cpp bidiagonalization.cpp gkh.cpp -o main_cuda
./main_cuda 2412592 2>&1 | tee result_cuda_O2.txt
```

截图：

- 编译命令中出现 `-DSVD_USE_CUDA`
- `通过: 5 / 5`
- `1000x1000` 的 `time bidiagonalization(ms)`
- 最后的总耗时

### 3.3 如果服务器是 AMD/HIP

如果不是 NVIDIA CUDA 环境，而是 HIP 环境，使用：

```bash
hipcc -std=c++17 -O2 -pthread -DSVD_USE_HIP bidiagonalization.cpp gkh.cpp main.cpp -o main_hip
./main_hip 2412592 2>&1 | tee result_hip_O2.txt
```

## 4. 必跑：通信/拷贝开销 profiling

代码已经增加可选 `SVD_PROFILE_GPU` 开关。正常编译不打印额外信息；只有加上该宏时，程序结束会在 `stderr` 打印一行：

```text
[SVD_GPU_PROFILE] h2d_ms=... d2h_ms=... kernel_sync_ms=... h2d_MB=... d2h_MB=... left_calls=... right_calls=...
```

运行：

```bash
nvcc -std=c++17 -O2 -DSVD_USE_CUDA -DSVD_PROFILE_GPU -x cu main.cpp bidiagonalization.cpp gkh.cpp -o main_cuda_profile
./main_cuda_profile 2412592 2>&1 | tee result_cuda_profile.txt
```

截图：

- `SVD_GPU_PROFILE` 这一行
- `h2d_ms`
- `d2h_ms`
- `kernel_sync_ms`
- `h2d_MB/d2h_MB`

报告可写：

> 通过 `SVD_PROFILE_GPU` 统计 Host-to-Device、Device-to-Host 和 kernel 同步耗时。结果显示当前实现每个 Householder 步会将相关矩阵重新拷入 GPU，并在更新后拷回主机，因此通信开销不可忽略。这也是手写 kernel 未必显著加速整体程序的重要原因。

## 5. 必跑：perf 简单 profiling

`perf` 主要看 CPU 侧热点，GPU kernel 内部不能靠它完整分析，但它适合说明 GKH 阶段和 CPU 调度开销。

```bash
perf stat -r 3 -d ./main_cuda_profile 2412592 2>&1 | tee perf_stat_cuda.txt
```

截图重点：

- `seconds time elapsed`
- `cycles`
- `instructions`
- `insn per cycle`
- `cache-misses`
- `branch-misses`

再跑热点采样：

```bash
perf record -F 99 -g ./main_cuda_profile 2412592
perf report --stdio --sort comm,dso,symbol > perf_report_cuda.txt
head -80 perf_report_cuda.txt
```

截图：

- `perf record` 采样完成提示
- `head -80 perf_report_cuda.txt` 的热点函数排名

报告可写：

> `perf report` 结果用于定位 CPU 侧热点。由于本实验只将 `to_bidiagonal` 中的 Householder 更新搬到 GPU，GKH 迭代仍在 CPU 侧执行，因此若热点集中在 GKH 相关函数，说明整体运行时间受后续迭代阶段主导。`perf` 不能替代 Nsight 对 GPU kernel 的细粒度分析，但足以完成本实验要求的简单 profiling。

## 6. 可选：课程 test.sh 正式提交数据

如果需要按课程脚本收集：

```bash
bash test.sh 5 1 4 -O O2 -s 2412592
cat test.o
cat test.e
```

如果 Lab 编号不是 `5`，把第一个参数换成课程平台要求的编号。

建议留存：

```bash
cp test.o test_O2_4cores_cuda.o
cp test.e test_O2_4cores_cuda.e
```

## 7. 最终报告截图清单

至少放这些截图：

1. `bidiagonalization.cpp` 中 `householder_dot_*` 和 `householder_*_update_kernel`。
2. `bidiagonalization.cpp` 中 `gpu_householder_left/right`。
3. `nvcc ... -DSVD_USE_CUDA ...` 编译命令。
4. `./main 2412592` 的 `通过: 5 / 5`。
5. `1000x1000` 的 `time bidiagonalization(ms)` 与 `time gkh iteration(ms)`。
6. `SVD_GPU_PROFILE` 输出。
7. `perf stat` 输出。
8. `perf report` 热点函数输出。

## 8. 最后建议写法

推荐报告结论：

> 本实验针对 SVD 流程中的上二对角化阶段进行 GPU 化。该阶段的 Householder 更新可以分解为 GEMV 和 GER 型操作，具有规则访存和元素级并行特征。实现中使用手写 CUDA kernel 替换原 CPU 循环，并保留 CPU/SIMD 回退路径。实验结果表明，GPU 版本在全部 5 个测试样例上保持正确。profiling 显示，由于当前框架仍在每个 Householder 步中进行主机与设备之间的数据拷贝，并且 GKH 迭代仍在 CPU 侧完成，因此整体加速效果受限。后续若继续优化，应将矩阵长期保留在 GPU 显存中，并考虑使用 cuBLAS 或融合 kernel 减少中间向量和数据传输开销。
