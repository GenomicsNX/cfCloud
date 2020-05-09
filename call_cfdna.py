


import csv
import sys
import argparse
from collections import defaultdict
import re
import pandas as pd
import vcf


def get_catg(obs_snp,rec,donor):
	
	if rec==donor:
		if obs_snp==rec:
			return "bg_rec"
		else:
			return "bg_err"
	else:
		if obs_snp==rec:
			return "homo_rec"
		elif obs_snp==donor:
			return "homo_donor"
		else:
			return "homo_err"
	return None

  	
nt_list=['A','C','G','T']



parser = argparse.ArgumentParser(description='')
parser.add_argument('--snps',dest='snps',help='SNP file')
parser.add_argument('--donor-id',dest='donor_id',help='donor ID')
parser.add_argument('--rec-id',dest='rec_id',help='recipient ID')
parser.add_argument('--sampleid',dest='sampleid',help='sample ID')
parser.add_argument('--pileup',dest='pileup_file',help='input pileup format file')
parser.add_argument('--bq',dest='bq',type=int,default=26,help='base quality Phred [26] Ascii +33')
parser.add_argument('--mq',dest='mapq',type=int,default=35,help='mapQ filter for alignment Phred [35]')
parser.add_argument('--filter_snps',dest='filter_snps',type=int,help='filter SNPs based on reference SNPs')
parser.add_argument('--ref_snps',dest='ref_snps',help='keep SNPs if they are in this file ')
parser.add_argument('--out',dest='out',help='output')


args = parser.parse_args()


donor_id=args.donor_id
rec_id=args.rec_id

pileup_file=args.pileup_file

bq_filter=args.bq
mq_filter=args.mapq
out=args.out



if args.filter_snps:
	dct_ref_snps=defaultdict(dict)
	for r in csv.reader(open(args.ref_snps),delimiter='\t'):
		k='%s-%s' %(r[0],r[2])
		dct_ref_snps[k]=1


dct_geno=defaultdict(dict)
for r in csv.DictReader(open(args.snps),delimiter='\t',quoting=csv.QUOTE_NONE):
	k='%s-%s' %(r['chr'],r['pos'])
	dct_geno[k]={'rec_base':r['rec_base'],'donor_base':r['donor_base']}


		
dd=defaultdict(int)
for tag in ['homo_rec','homo_donor','homo_err','bg_rec','bg_err']:
	dd[tag]=0


_re_del=re.compile('\^.|\$')

for r in csv.reader(open(pileup_file),delimiter='\t',quoting=csv.QUOTE_NONE):
	if re.search('[*+-]',r[4]):
		continue

	k='%s-%s' %(r[0],r[1])

	if k not in dct_geno:
		continue

	if args.filter_snps:
		if k not in dct_ref_snps:
			continue


	r[4]=_re_del.sub('',r[4])

	for obs_snp,bq,mq,seq_pos in zip(list(r[4]),list(r[5]),list(r[6]),r[7].split(',')):

		obs_snp=obs_snp.upper()

		if obs_snp=="N":
			continue		
		#if obs_snp=="$":
		#	continue

		if obs_snp=="." or obs_snp==",":
			obs_snp=r[2].upper()

		if int(ord(bq)-33) < bq_filter:
			continue

		if int(ord(mq)-33) < mq_filter:
			continue

		catg=get_catg(obs_snp,dct_geno[k]['rec_base'],dct_geno[k]['donor_base'])
		dd[catg]=dd[catg]+1
		


		
dd['total_counts']=dd['homo_donor']+dd['homo_rec']

try:		
	dd['%cfdna']=dd['homo_donor']/(dd['homo_rec']+dd['homo_donor'])*100
except:
	dd['%cfdna']=0

try:
	dd['%error']=dd['bg_err']/dd['bg_rec']*100
except:
	dd['%error']=0


	

with open(out,'w') as fout:
	fout.write('sampleID\tRecID\tDonorID\tTotalCounts\tDonorCounts\t%cfdna\t%bgError\n')
	fout.write('%s\t%s\t%s\t' %(args.sampleid,rec_id,donor_id))
	
	for tag in ['total_counts','homo_donor','%cfdna','%error']:
		fout.write('%s\t' %dd[tag])
	fout.write('\n')
	
