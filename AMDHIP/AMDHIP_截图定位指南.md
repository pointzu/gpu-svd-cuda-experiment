# AMD HIP Notebook 截图定位指南

## 使用原则

- 报告正文主要写代码填空和分析填空。
- GPU 型号、Compute Units、Wavefront Size 这类简单环境信息可以不写进报告，但过程截图可以保留。
- 需要证明“运行过”的地方，优先截图运行输出、性能表和生成的图。
- 本地 notebook 修改不会自动同步到服务器。如果在服务器 JupyterLab 里跑，需要把本地更新后的 notebook 上传/覆盖到对应 lab 目录。

## Lab1: Vector Add

Notebook: `lab1/Lab1_vadd.ipynb`

必截：

1. 标题 `## 8. Confirm Your GPU & Run Multi-Trial Experiments`
   - 定位输出：`=== GPU Detection ===`
   - 内容：GPU 检测信息和 wavefront size。这个不一定放报告正文，但可作为运行环境证明。

2. 同一节下面的多轮 block size benchmark
   - 定位表头：`Block Size  Mean (ms)  Std (ms)  Min (ms)  Max (ms)  Trials`
   - 内容：16/32/64/128/256/512/1024 的平均时间表。
   - 对应报告结论：block size 512 最快，mean time `0.1382 ms`。

3. 标题 `## 11. Experiment: Effect of Sub-Wavefront Block Sizes`
   - 定位表头：`Block Size  Mean (ms)  Std (ms)  Sub-Wave?`
   - 内容：8/16/32/64/128/256 的 sub-wavefront 表。
   - 对应报告结论：block size 8 最慢，sub-wavefront 会浪费 lane。

可选：

- 标题 `### Exercise 4: Analyze Your Results`
- 标题 `### Exercise 7: Analyze Sub-Wavefront Results`
- 生成图：`block_size_performance.png`、`sub_wavefront_impact.png`

## Lab2: Matrix Transpose

Notebook: `lab2/Lab2_Transpose.ipynb`

必截：

1. 标题 `## 5. Setup: Generate Test Data`
   - 内容：testcases 生成成功。

2. 编译 cell
   - 定位命令：`hipcc -O2 fs_main.hip -o exe_transpose`
   - 内容：编译成功或没有报错。

3. 标题 `## 7. Run Test Cases & Multi-Trial Benchmark`
   - 定位代码：`# Multi-trial benchmark — parse real kernel time from stderr (HIP events)`
   - 内容：包含 Test 1/2/3/4 的 `Mean (ms)` 表。
   - 对应报告数据：`0.0077 ms`、`0.0108 ms`、`0.0087 ms`、`0.2352 ms`。

4. 性能图 cell
   - 定位输出：`Saved: transpose_kernel_time.png`
   - 内容：kernel time 和 per-element cost 图。

可选：

- 标题 `### Exercise 3: Performance Analysis`
- 标题 `### Exercise 4: Coalescing Analysis`
- 标题 `### Exercise 5: Tiled Transpose Analysis`

## Lab3: Histogram

Notebook: `lab3/Lab3_Histogram.ipynb`

必截：

1. 标题 `3. Setup: Generate Test Data`
   - 内容：生成 `testcases/` 的输出。

2. 标题 `4. Compile All Implementations`
   - 内容：`exe_serial`、`exe_bad`、`exe_optimized` 编译成功。

3. `Quick sanity run of the bad implementation`
   - 定位输出：`Naive run OK`

4. `Quick sanity run of the optimized implementation + correctness check`
   - 定位输出：`Optimized matches serial`

5. 标题 `7. Performance Comparison (real compute time)`
   - 定位代码/输出：`Multi-trial benchmark ... KERNEL_MS`
   - 内容：6 行 `mean=... ms`：

```text
Test 2 (medium) Serial CPU
Test 2 (medium) Naive GPU
Test 2 (medium) Optimized GPU
Test 4 (large)  Serial CPU
Test 4 (large)  Naive GPU
Test 4 (large)  Optimized GPU
```

6. benchmark 后面的画图 cell
   - 定位标题：`Speedup of Optimized GPU`
   - 内容：性能柱状图和 speedup 图。

7. 标题 `9. Contention Analysis`
   - 定位代码：`Atomic contention experiment`
   - 内容：Uniform / Gaussian / All-same 的时间输出和 `histogram_contention.png`。

可选：

- 标题 `### Exercise 3: Record Results`

## Lab4: Reduction

Notebook: `lab4/Lab4_Reduction.ipynb`

这个 notebook 已加了清晰的截图标题，按标题搜索最方便。

必截：

1. `=== SCREENSHOT 1: Small Test (N=10) ===`
2. `=== SCREENSHOT 2: Medium Test (N=1M) ===`
3. `=== SCREENSHOT 3: Occupancy Sweep (Tree Reduction, N=1M) ===`
4. `=== SCREENSHOT 4: Large Test (N=100M) ===`
5. `=== SCREENSHOT 5: Benchmark with N=1M (testcases/2.in) ===`

对应报告重点：

- Occupancy sweep 中 block size 256 最快，time `0.0641 ms`。
- Benchmark 中 `Multi-Element + Tree + Shuffle` 最快，time `0.0478 ms`。
- 所有策略结果相同，说明优化没有改变正确性。

可选：

- 标题 `### Exercise 2: Analyze Occupancy Results`
- 标题 `### Recorded Result: Occupancy Sweep`
- 标题 `### Recorded Result: Large Test`

## Lab5: Monte Carlo Integration

Notebook: `lab5/Lab5_MonteCarlo.ipynb`

必截：

1. 标题 `## 3. Setup: Generate Test Data`
   - 内容：testcases 生成成功。

2. 标题 `## 4. Compile the Program`
   - 内容：`hipcc -O2 fs_main.hip -o exe_montecarlo` 编译成功。

3. 标题 `## 5. Run Small Test Cases`
   - 截两个小测试：
     - `=== Test 1: Small sample (N=8) ===`
     - `=== Test 2: Single sample (N=1) ===`

4. 标题 `## 6. Performance Scaling`
   - 截三个性能测试：
     - `=== Test 4: N=100,000 ===`
     - `=== Test 7: N=10,000,000 ===`
     - `=== Test 8: N=100,000,000 ===`
   - 重点截 `real` 时间。

对应报告数据：

```text
Test 4: real 0m0.074s
Test 7: real 0m0.878s
Test 8: real 0m8.425s
```

可选：

- 标题 `### Exercise 2: Manual Calculation`
- 标题 `### Exercise 3: Scalability Analysis`
- 标题 `### Exercise 6: Optimization Analysis`

## Lab6: K-Means

Notebook: `lab6/Lab6_KMeans.ipynb`

必截：

1. 标题 `## 3. Setup: Generate Test Data`
   - 内容：testcases 生成成功。

2. 标题 `## 4. Compile the Program`
   - 内容：`hipcc -O2 main.hip -o exe_kmeans` 编译成功。

3. 标题 `## 5. Run Test Cases`
   - 截：
     - `=== Test 1: Small random case ===`
     - `=== Test 3: Minimal case (N=1, k=1) ===`
     - `=== Test 4: Large case (N=50000, k=50) ===`

4. Test 4 的时间输出
   - 定位命令：`time ./exe_kmeans < testcases/4.in > /dev/null`
   - 内容：`real 0m0.085s`

5. 标题 `### Exercise 2: Performance Analysis`
   - 内容：填入实际执行时间后的结果。

可选：

- 标题 `### Exercise 1: Algorithm Analysis`
- 标题 `### Exercise 4: Memory Optimization`
- 标题 `### Exercise 5: Convergence Analysis`

## 最终提交前检查

1. 每个 notebook 能打开，没有 JSON 格式损坏。
2. 报告里只放主要代码与分析结论，不需要把 GPU 型号等简单环境空重复写入。
3. 截图文件名建议按 `lab编号_序号_内容.png` 命名，例如：

```text
lab1_01_gpu_detection.png
lab1_02_block_size_benchmark.png
lab4_03_occupancy_sweep.png
lab5_04_scaling_test8.png
```

4. 若服务器输出和报告中已有数字不同，以服务器最新截图和输出为准，再更新报告。
