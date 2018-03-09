#!/bin/bash
##### merge BAM files

##### bash mergeBAMs.sh $BAMLIST

## $BAMLIST = a newline separated textfile of BAMs

## add modules

## define variables
BAMLIST=`echo $1`
NAME=`basename $BAMLIST .BAMlist`

## write a tempscript to be looped over
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.mergeBAMs
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

########## Commands
## merge BAMs
samtools merge --threads 12 -b $BAMLIST -n $NAME.merged.bam
##
EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh 
sleep 1
# rm $NAME.tempscript.sh
