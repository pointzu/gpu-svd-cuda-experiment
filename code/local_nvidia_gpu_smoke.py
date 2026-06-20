import json
import time

import torch


def synchronize():
    if torch.cuda.is_available():
        torch.cuda.synchronize()


def timed_ms(fn, repeat=20, warmup=5):
    for _ in range(warmup):
        fn()
    synchronize()
    start = time.perf_counter()
    for _ in range(repeat):
        fn()
    synchronize()
    end = time.perf_counter()
    return (end - start) * 1000.0 / repeat


def timed_cuda_event_ms(fn, repeat=20, warmup=5):
    for _ in range(warmup):
        fn()
    synchronize()
    start = torch.cuda.Event(enable_timing=True)
    end = torch.cuda.Event(enable_timing=True)
    start.record()
    for _ in range(repeat):
        fn()
    end.record()
    synchronize()
    return start.elapsed_time(end) / repeat


def main():
    result = {
        "torch_version": torch.__version__,
        "cuda_available": torch.cuda.is_available(),
        "torch_cuda_version": torch.version.cuda,
    }
    if not torch.cuda.is_available():
        print(json.dumps(result, ensure_ascii=False, indent=2))
        raise SystemExit(1)

    device = torch.device("cuda:0")
    props = torch.cuda.get_device_properties(device)
    result.update(
        {
            "gpu_name": props.name,
            "compute_capability": f"{props.major}.{props.minor}",
            "total_memory_mib": round(props.total_memory / 1024 / 1024, 1),
        }
    )

    n = 4096
    torch.manual_seed(2412592)
    a_cpu = torch.randn((n, n), dtype=torch.float32)
    b_cpu = torch.randn((n, n), dtype=torch.float32)

    def cpu_mm():
        return a_cpu @ b_cpu

    cpu_ms = timed_ms(cpu_mm, repeat=3, warmup=1)

    a_gpu = a_cpu.to(device)
    b_gpu = b_cpu.to(device)

    def gpu_mm():
        return a_gpu @ b_gpu

    gpu_ms = timed_cuda_event_ms(gpu_mm, repeat=20, warmup=5)
    c_gpu = gpu_mm()
    c_cpu_ref = cpu_mm()
    max_abs_diff = (c_gpu.cpu() - c_cpu_ref).abs().max().item()

    # Householder-like micro-kernel pattern: GEMV followed by GER-style update.
    m = 4096
    k = 0
    mat = torch.randn((m, m), dtype=torch.float32, device=device)
    vec = torch.randn((m - k,), dtype=torch.float32, device=device)
    beta = torch.tensor(1.25, dtype=torch.float32, device=device)

    def gpu_householder_like():
        sub = mat[k:, k:]
        w = vec @ sub
        return sub - beta * torch.outer(vec, w)

    householder_ms = timed_cuda_event_ms(gpu_householder_like, repeat=20, warmup=5)

    result.update(
        {
            "matrix_size": n,
            "cpu_matmul_ms": round(cpu_ms, 3),
            "gpu_matmul_ms": round(gpu_ms, 3),
            "matmul_speedup": round(cpu_ms / gpu_ms, 2),
            "max_abs_diff": max_abs_diff,
            "householder_like_size": m,
            "gpu_householder_like_ms": round(householder_ms, 3),
        }
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
