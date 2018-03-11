#!/bin/bash
##### Check breadth and depth of coverage for exome seq

# for x in `/bin/ls *.bam` ; do bash bamToBed.sh $x; done

## add modules
module add bedtools

## define variables
name=`basename $1 .bam`

cat > $name.tempscript.sh << EOF
#!/bin/bash
#$ -N $name.bamToBed
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=6G
#$ -pe shm 4
#$ -l h_rt=11:59:00
#$ -l s_rt=11:59:00

## run commands
##usage: bamToBed [OPTIONS] -i <BAM>
bamToBed -i $1 > $name.bed
EOF

## qsub then remove the tempscript
qsub $name.tempscript.sh
sleep 1
rm $name.tempscript.sh
