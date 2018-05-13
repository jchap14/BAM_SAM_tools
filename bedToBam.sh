#!/bin/bash
##### Convert BED to BAM

##### submit for all samples in CWD
# for x in `/bin/ls *.bed` ; do bash bedToBam.sh $x; done

## add modules or activate environments
source activate aquas_chipseq

## define variables
BEDFILE=`echo $1`
NAME=`basename $BEDFILE .bed`
GENOME="/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/WholeGenomeFasta/genome.fa"

## write a tempscript to be looped over
cat > $NAME.tempscript.sh << EOF
#!/bin/bash -l
#SBATCH --job-name $NAME.subSampBAM
#SBATCH --output=$NAME.subSampBAM.out
#SBATCH --mail-user jchap14@stanford.edu
#SBATCH --mail-type=ALL
# Request run time & memory
#SBATCH --time=5:59:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --account=mpsnyder

## add modules or activate environments
source activate aquas_chipseq

########## Commands
##
echo "bedtools bedtobam -i $BEDFILE -g $GENOME > $NAME.bam"
bedtools bedtobam -i $BEDFILE -g $GENOME > $NAME.bam
##
EOF

## qsub then remove the tempscript
sbatch $NAME.tempscript.sh 
sleep 1
rm $NAME.tempscript.sh
