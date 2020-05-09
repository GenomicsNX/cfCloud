#!/bin/bash


resPath="results"

snakemake -pr -k -d $resPath -j 120 --latency-wait 120 --cluster-config cluster_config.yaml --cluster "sbatch --cpus-per-task={cluster.cpus} \
--mem={cluster.mem} --time={cluster.time} -o {cluster.out} -e {cluster.out} -J {cluster.jobname}"
