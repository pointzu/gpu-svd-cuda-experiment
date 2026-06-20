# SVD 服务器操作指南

## 1. 先确认这几条红线

按照 `code/README.md`：

- 不要修改 `main.cpp`。
- 不要修改 `test.sh` 和 `qsub.sh`。
- 不要在登录节点直接运行 `./main`。
- 必须通过 `bash test.sh ...` 提交运行，让 qsub 在计算节点上执行。
- `test.o` 是主要输出，`test.e` 是错误/警告输出。

本次本地只整理了算法实现文件：

- `bidiagonalization.cpp`: Householder 处的 SIMD TODO 注释已改成已实现说明，算法行为不变。
- `gkh.cpp`: 已存在 pthread/OpenMP/MPI 运行路径，本次未改动。

## 2. 连接服务器

把 `2222222` 替换为你的学号：

```bash
ssh -J s2222222@10.137.144.91:9001 s2222222@192.168.90.141
```

VS Code Remote-SSH 配置示例：

```sshconfig
Host s2222222
  HostName 192.168.90.141
  ProxyJump s2222222@10.137.144.91:9001
  User s2222222
```

登录后进入你的 SVD 选题目录，通常类似：

```bash
cd ~/svd
```

如果目录名不同，先用：

```bash
ls
```

找到包含 `README.md`、`main.cpp`、`bidiagonalization.cpp`、`gkh.cpp`、`test.sh` 的目录。

## 3. 上传/同步代码

推荐用 VS Code Remote-SSH 直接打开服务器目录，把本地 `C:\Users\pointzu\Desktop\大二下\并行程序设计\GPU\code` 中需要同步的文件覆盖到服务器同名目录。

只需要同步这些算法实现相关文件：

```text
bidiagonalization.cpp
bidiagonalization.h
gkh.cpp
gkh.h
givens.h
matrix.h
```

不要覆盖或编辑：

```text
main.cpp
test.sh
qsub.sh
qsub_mpi.sh
```

上传前可以在服务器先备份：

```bash
cp bidiagonalization.cpp bidiagonalization.cpp.bak.$(date +%Y%m%d_%H%M%S)
cp gkh.cpp gkh.cpp.bak.$(date +%Y%m%d_%H%M%S)
```

## 4. 正式运行

README 写法是：

```bash
bash test.sh [LAB] [NODES] [CORES] [-O <opt>] [-s <seed>]
```

当前 README 说明 SIMD 实验编号为 `1`，所以优先用：

```bash
bash test.sh 1 1 4 -O O2 -s 20260410
```

如果脚本提示 LAB 编号不对，就把第一个 `1` 换成课程通知里指定的 SVD/GPU Lab 编号。后面的 `1 4` 分别表示申请 1 个节点、每节点 4 核。

运行后不要直接等屏幕输出完整结果，使用：

```bash
qstat
qstat -n
```

查看任务状态。

如果发现任务明显卡死或误提交，先查 qsub 编号，然后终止：

```bash
qdel num.master_ubss1
```

## 5. 查看结果

任务完成后查看：

```bash
cat test.o
cat test.e
```

`test.o` 中应该重点确认：

```text
converged                 : yes
relative recon error      : 很小
||U^T U-I||_F             : 很小
||V^T V-I||_F             : 很小
diagonal structure error  : 0
descending order error    : 0
nonnegative diagonal      : yes
结果: PASS
通过: 5 / 5
```

`test.e` 里如果只有下面这类信息，一般不影响结果：

```text
Authorized users only. All activities may be monitored and reported.
```

如果出现编译错误、段错误、长时间无输出、`FAIL`，把 `test.o` 和 `test.e` 的内容保存下来再处理。

## 6. 建议保存多组优化等级结果

为了报告里能比较优化等级，可以依次运行：

```bash
bash test.sh 1 1 4 -O O0 -s 20260410
cp test.o test_O0_4cores.o
cp test.e test_O0_4cores.e

bash test.sh 1 1 4 -O O1 -s 20260410
cp test.o test_O1_4cores.o
cp test.e test_O1_4cores.e

bash test.sh 1 1 4 -O O2 -s 20260410
cp test.o test_O2_4cores.o
cp test.e test_O2_4cores.e

bash test.sh 1 1 4 -O O3 -s 20260410
cp test.o test_O3_4cores.o
cp test.e test_O3_4cores.e

bash test.sh 1 1 4 -O Ofast -s 20260410
cp test.o test_Ofast_4cores.o
cp test.e test_Ofast_4cores.e
```

如果课程只要求一次正式提交，至少保留 `O2` 的 `test.o/test.e`。

## 7. SVD 部分建议截图

服务器侧建议保留这些截图：

1. VS Code/终端中 `~/svd` 目录文件列表，能看到 `README.md`、`bidiagonalization.cpp`、`gkh.cpp`、`test.sh`。
2. `bidiagonalization.cpp` 中 `simd_sum_squares`、`simd_dot`、`simd_add_scaled` 附近代码。
3. `gkh.cpp` 中 `SVD_MODE` / `SVD_THREADS`、`PthreadBlockPool` 或 OpenMP 分支附近代码。
4. 执行命令 `bash test.sh 1 1 4 -O O2 -s 20260410` 的终端截图。
5. `qstat` 或 `qstat -n` 显示任务运行/排队的截图。
6. `cat test.o` 中 5 个 case 都 `PASS`，最后显示 `通过: 5 / 5` 的截图。
7. `cat test.o` 中总耗时两行：

```text
总上二对角化耗时(ms): ...
总GKH迭代耗时(ms): ...
```

8. `cat test.e` 截图。如果只有授权提示，可以作为“无关键错误”证明；如果有报错，需要保留给排错。

## 8. 本地验证记录

本地 Windows smoke test 已通过普通 C++ 编译：

```bash
g++ -std=c++17 -O2 -pthread -I ..\code ..\code\main.cpp ..\code\bidiagonalization.cpp ..\code\gkh.cpp -o .\svd_check.exe
.\svd_check.exe 20260410
```

结果为 `通过: 5 / 5`。这只证明本地语法和基础正确性，不能替代服务器 qsub 提交。
