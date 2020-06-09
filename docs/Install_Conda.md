### Conda Environment

#### 1. Download and install conda

Download an an installer for Python v3. (cfCloud requires python=3.7)

distribution  | instructions
---- | ----
[Anaconda](https://www.anaconda.com/products/individual#download-section) | Current version "Python 3.7 version"
[Miniconda](https://repo.anaconda.com/miniconda/) | Download the `Miniconda3-latest-*` installer based on your operating system

Run the installer file.  Depends on. your OS. It may be an executable installer or run from the command-line: `bash INSTALLER.sh` . Please see the instruction provided with the installer.
```
# Example:
wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
bash Anaconda3-2020.02-Linux-x86_64.sh
```



#### 2. Create a new environment 
```
conda create --name cfcloud python=3.6
conda activate cfcloud
conda info --envs
```


#### 3. Tool Prerequisites
```shell
conda install -c anaconda pandas -y
conda install -c bioconda snakemake -y
conda install -c bioconda bcftools -y
conda install -c bioconda samtools -y
conda install -c bioconda pyvcf -y
conda list
```

#### 4. Clone cfCloud
```
git clone https://github.com/NHLBI-BCB/cfCloud.git
cd cfCloud
```
<br />

#### 5. Install resources

- Bowtie2 Reference Genome <br />
Can be downloaded from [Illumina iGenomes](https://support.illumina.com/sequencing/sequencing_software/igenome.html)

```
# e.g. hg19:
cd resources
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Homo_sapiens/UCSC/hg19/Homo_sapiens_UCSC_hg19.tar.gz
tar -xzf Homo_sapiens_UCSC_hg19.tar.gz
```
<br />

- SNPs list <br />
Can be downloaded from [Illumina Genotyping Kits](https://www.illumina.com/products/by-type/microarray-kits.html)
```
# e.g. Infinium Omni2.5:
cd reources
unzip InfiniumOmni25.hg19.snps.cleaned.zip
```

<br /><br />




<hr size=5 style="display: block; height: 3px;
    border: 0; border-top: 1px solid #ccc;
    margin: 1em 0; padding: 0;"  />
<br /><br />
