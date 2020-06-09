### Local Installation

#### 1. Tool Prerequisites

- [python=3.7](https://www.python.org/downloads/) 
- [samtools and bcftools](https://samtools.github.io/bcftools/howtos/install.html) 
```
    git clone --branch=develop git://github.com/samtools/htslib.git
    git clone --branch=develop git://github.com/samtools/bcftools.git
    git clone --branch=develop git://github.com/samtools/samtools.git
    cd bcftools; make
    cd ../samtools; make 
```

- [PyVCF](https://pypi.org/project/PyVCF/)
```
pip3 install PyVCF
```
- [pandas](https://pandas.pydata.org/)
```
pip3 install pandas
```
- [snakemake](https://snakemake.readthedocs.io/en/stable/index.html)
```
pip3 install snakemake
```
<br />

#### 2. Clone cfCloud
```
git clone https://github.com/NHLBI-BCB/cfCloud.git
cd cfCloud
```
<br />

#### 3. Install resources

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

</details>
<details>
<summary>
Conda Environment
</summary>

<hr size=5 style="display: block; height: 3px;
    border: 0; border-top: 1px solid #ccc;
    margin: 1em 0; padding: 0;"  />
