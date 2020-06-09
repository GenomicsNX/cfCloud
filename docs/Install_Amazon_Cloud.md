### Amazon Cloud

<p align="center">
  <img src="https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/images/overview_getting_started.png" width="409" height="338" title="AWS">
</p>
 


#### 1. Tutorial: Getting started with Amazon EC2 Linux instances

Tutorail: <b>[AWS EC2: Create EC2 Instance (Linux)](https://medium.com/@GalarnykMichael/aws-ec2-part-1-creating-ec2-instance-9d7f8368f78a)</b><br /><br />
<b>Step-by-step:</b><br />
&nbsp;&nbsp;&nbsp;&nbsp; [Step 1: Prerequisites](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html)<br />
&nbsp;&nbsp;&nbsp;&nbsp; [Step 2: Launch an instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html)<br />
&nbsp;&nbsp;&nbsp;&nbsp; [Step 3: Connect to your instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html)<br />
&nbsp;&nbsp;&nbsp;&nbsp; [Step 4: Clean up your instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html#ec2-clean-up-your-instance)<br />

#### 2. Choose the cfCloud Amazon Machine Image (AMI)

&nbsp;&nbsp;&nbsp;&nbsp; 2.1. On the <b>[Choose an Amazon Machine Image (AMI)](https://console.aws.amazon.com/ec2/v2/home?#LaunchInstanceWizard:)</b> page, search for <b>cfCloud</b> AMI.<br />

&nbsp;&nbsp;&nbsp;&nbsp; 2.2. Check the Root device type listed for each AMI. Notice which AMIs are the type that you need, <br />&nbsp;&nbsp;&nbsp;&nbsp; either ebs (backed by Amazon EBS) or instance-store (backed by instance store). <br />

&nbsp;&nbsp;&nbsp;&nbsp; 2.3. Check the Virtualization type listed for each AMI. Notice which AMIs are the type that you need,<br /> &nbsp;&nbsp;&nbsp;&nbsp; either hvm or paravirtual.  <br />

&nbsp;&nbsp;&nbsp;&nbsp; 2.4. Choose an AMI that meets your needs, and then choose Select.<br />

#### 3. Connect (login) to AMI and activate cfCloud environment

Tutorial: [AWS EC2: Connect to Linux Instance using SSH](https://medium.com/@GalarnykMichael/aws-ec2-part-2-ssh-into-ec2-instance-c7879d47b6b2)

```
# Example SSH:
ssh -i "cf_Cloud.pem" ubuntu@30.95.174.61
```
```
conda info --envs
conda activate cfcloud
```

#### 4. Download resources

- Bowtie2 Reference Genome <br />
Can be downloaded from [Illumina iGenomes](https://support.illumina.com/sequencing/sequencing_software/igenome.html)

```
# e.g. hg19:
cd ~/cfCloud/resources
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Homo_sapiens/UCSC/hg19/Homo_sapiens_UCSC_hg19.tar.gz
tar -xzf Homo_sapiens_UCSC_hg19.tar.gz
```



