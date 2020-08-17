#!/bin/bash


resPath="results"

snakemake -pr -k -d $resPath --configfile config.yaml 




