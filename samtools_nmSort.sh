#!/bin/bash

##### Submit this script for CUT&RUN
## for x in `find . -name "*.bam" -not -name "*.yst.bam"` ; do bash samtools_nmSort.sh $x; done

##### load required modules
# samtools in conda environment

##### set variables
BAMFILE=`echo $1`
#NAME=`basename $BAMFILE .Aligned.sortedByCoord.out.bam`
NAME=`basename $BAMFILE .bam`
annoDir="/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19"

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.nmSort
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=1G
#$ -pe shm 12

##################	sort BAMs by name
samtools sort -n $BAMFILE > $NAME.nmSort.bam
EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh

