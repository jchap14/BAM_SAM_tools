#!/bin/bash

##### Submit this script
## for x in `find . -name "*.bam" -not -name "*.yst.bam"` ; do bash samtools_flagstat.sh $x; done

##### NOTE: flagstat #'s are for single end reads & include secondary mappings

##### load required modules (unless in conda environment)
# module add samtools

##### set variables
BAMFILE=`echo $1`
NAME=`basename $BAMFILE .bam`
annoDir="/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19"

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.flagstat
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=1G
#$ -pe shm 12

## get the flagstats
samtools flagstat $BAMFILE > $NAME.flagstats.qc

EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
