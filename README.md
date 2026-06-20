# GPU Programming Lab and SVD CUDA/HIP Experiment

This repository contains the course materials, source code, experiment outputs, and report for the parallel programming GPU lab.

## Contents

- `code/`: SVD implementation and local/server run outputs.
- `AMDHIP/`: AMD HIP notebook screenshots and LaTeX report.
- `AMDHIP/latex_report/main.pdf`: final experiment report.
- `AMDHIP/latex_report/svd_*.png`: charts used in the data analysis section.

## Local CUDA C++ SVD Build

On Windows with CUDA Toolkit 13.3 and Visual Studio 2022 Build Tools:

```bat
cl /std:c++17 /O2 /EHsc /DNOMINMAX /utf-8 /c main.cpp gkh.cpp
nvcc -x cu -std=c++17 -O2 -DSVD_USE_CUDA -DSVD_PROFILE_GPU ^
  -Xcompiler "/utf-8 /EHsc /DNOMINMAX" ^
  -c bidiagonalization.cpp -o bidiagonalization_cuda.obj
nvcc main.obj gkh.obj bidiagonalization_cuda.obj -o svd_cuda.exe
svd_cuda.exe 2412592 > local_nvcc_cuda_run.txt 2>&1
```

The local CUDA C++ path passed all 5 test cases. Profiling showed that the GPU kernels were correct, while host-device transfer dominated the end-to-end time.
