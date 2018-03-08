#!/bin/bash
##### Generate BAM files with equal number of reads in each

##### bash subSample_by_lowest.sh $BAMLIST

## $BAMLIST = a newline separated textfile of BAMs (subsampled to equal read #)

## add modules
module add MACS2

## define variables
BAMLIST=`echo $1`
NAME=`basename $BAMLIST .BAMlist`

## write a tempscript to be looped over
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.subSampBAM
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

########## Commands
## create an empty file called $NAME.lineCount
touch $NAME.lineCount
## count the # of alignments in each BAM
for line in \`cat $BAMLIST\`
do
samtools flagstat \$line > flagstat.TEMP
cat flagstat.TEMP | egrep "read1" | cut -f1 -d ' ' >> $NAME.lineCount 
done
## find the BAM with the lowest # & set it as a variable
MIN=\`cat $NAME.lineCount | sort -n | head -1\`
## subsample each BAM to the MIN # of reads
for line in \`cat $BAMLIST\`
do
macs2 randsample -t \$line -o \$line.subSamp.bam -n $MIN 
##
EOF

## qsub then remove the tempscript
# qsub $NAME.tempscript.sh 
sleep 1
# rm $NAME.tempscript.sh
