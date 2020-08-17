import pandas as pd
from collections import defaultdict
import vcf



SAMPLES = list(config['samples'].keys())
os.makedirs("logs",exist_ok=True)


rule all:
	input:
		expand("bam/{sample}.bam",sample=SAMPLES),
		expand("snps/{sample}.snps",sample=SAMPLES),
		expand("pileup/{sample}.pileup",sample=SAMPLES),
		expand("calls/{sample}.calls",sample=SAMPLES),
		"final.tsv"

		

		
rule bowtie:
	input:
		config['fastqPath']+"/{sample}.fastq.gz"
	output:
		"bam/{sample}.bam"
	params:
		threads=4,
		index=config['bowtie_index'],
		log="logs/bowtie_{sample}.out",
		mem="4G"
	shell:
		"bowtie2 -p {params.threads} -x {params.index} -U {input} \
		| samtools sort -m {params.mem} -@ {params.threads} | samtools markdup - {output} "
				

		

rule grep_snps_from_vcf:
	input:
		config['GenoVCF'],
	output:
		"snps/{sample}.vcf",
	params:
		log="logs/grep_snps_{sample}.out",
		rec_id=lambda wildcards: config['samples'][wildcards.sample]['rec_id'],
		donor_id=lambda wildcards: config['samples'][wildcards.sample]['donor_id'],
	shell:
		"bcftools query -f '%CHROM,%POS,%ID,%REF,%ALT[,%GT]\n' -s {params.rec_id},{params.donor_id} {input} > {output}	"



		
rule make_snps:
	input:
		"snps/{sample}.vcf",
	output:
		"snps/{sample}.snps",
	params:
		log="logs/make_snps_{sample}.out",
		rec_id=lambda wildcards: config['samples'][wildcards.sample]['rec_id'],
		donor_id=lambda wildcards: config['samples'][wildcards.sample]['donor_id'],
	run:
		df=pd.read_csv(input[0],header=None)

		chr_list=['chr%s' %x for x in list(range(1,23))+['X']]
		
		df.columns=['chr','pos','rsid','ref','alt','GT_rec','GT_donor']
		df=df.loc[ (df['GT_rec']=="0/0") | (df['GT_rec']=="1/1") ,: ]
		df=df.loc[ (df['GT_donor']=="0/0") | (df['GT_donor']=="1/1") ,: ]

		df.loc[df['GT_rec']=="0/0",'rec_base']=df.loc[df['GT_rec']=="0/0",'ref']
		df.loc[df['GT_rec']=="1/1",'rec_base']=df.loc[df['GT_rec']=="1/1",'alt']

		df.loc[df['GT_donor']=="0/0",'donor_base']=df.loc[df['GT_donor']=="0/0",'ref']
		df.loc[df['GT_donor']=="1/1",'donor_base']=df.loc[df['GT_donor']=="1/1",'alt']

		df=df.loc[df['chr'].isin(chr_list),:]
		df.to_csv(output[0],sep='\t',index=False)
		shell("rm {input} ")

		
		
rule mileup:
	input:
		bam="bam/{sample}.bam",
		snps="snps/{sample}.snps"
	output:
		"pileup/{sample}.pileup",
	params:
		log="logs/mpileup_{sample}.out",
		ref=config['human_fasta'],
		samtools018="/home/tunci/tools/samtools-0.1.18/samtools"
	shell:
		"awk 'NR >1 {{print $1,$2}}' {input.snps} > {output}.pos.tmp ;"
		"samtools mpileup -O -s -f {params.ref} -l {output}.pos.tmp {input.bam} > {output} ;"
		"rm {output}.pos.tmp "


	

rule call_cfdna:
	input:
		pileup="pileup/{sample}.pileup",
		snps="snps/{sample}.snps",		
	output:
		"calls/{sample}.calls",
	params:
		log="logs/make_snps_{sample}.out",
		rec_id=lambda wildcards: config['samples'][wildcards.sample]['rec_id'],
		donor_id=lambda wildcards: config['samples'][wildcards.sample]['donor_id'],
		bq_filter=config['bq_filter'],
		mq_filter=config['mq_filter'],
		ref_snps=config['ref_snp'],
		filter_snps=config['filter_snps']
	shell:
		"python {config[binPath]}/call_cfdna.py "
		"--snps {input.snps} "
		"--rec-id {params.rec_id} "
		"--sampleid {wildcards.sample} "		
		"--donor-id {params.donor_id} "
		"--pileup {input.pileup} "
		"--bq {params.bq_filter} "
		"--mq {params.mq_filter} "
		"--ref_snps {params.ref_snps} "
		"--filter_snps {params.filter_snps} "		
		"--out {output} "




		
rule final_report:
	input:
		expand("calls/{sample}.calls",sample=SAMPLES)
	output:
		"final.tsv"
	run:
		dfm=None
		for f in input:
			df=pd.read_csv(f,sep='\t')
			if dfm is None:
				dfm=df
				continue
			dfm=dfm.append(df)
		dfm.to_csv(output[0],sep='\t')

