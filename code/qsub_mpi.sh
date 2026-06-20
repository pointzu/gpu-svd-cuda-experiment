#!/bin/sh
#PBS -N qsub_mpi
#PBS -e test.e
#PBS -o test.o
#PBS -l nodes=1:ppn=4

NODES=$(cat $PBS_NODEFILE | sort | uniq)

for node in $NODES; do
    scp master_ubss1:/home/${USER}/svd/main ${node}:/home/${USER} 1>&2
    scp -r master_ubss1:/home/${USER}/svd/files ${node}:/home/${USER}/ 1>&2
done

/usr/local/bin/mpiexec -np 4 -machinefile $PBS_NODEFILE sh -c 'rank=${PMI_RANK:-${OMPI_COMM_WORLD_RANK:-0}}; host=$(hostname); out=/home/${USER}/files/perf/perf_np4_${host}_${rank}.txt; perf stat -d -d -d -o "$out" /home/${USER}/main 2412592; scp "$out" master_ubss1:/home/${USER}/svd/files/perf/ 1>&2'

scp -r /home/${USER}/files/ master_ubss1:/home/${USER}/svd/ 2>&1
