#!/bin/bash

##### Submit this script for CUT&RUN
## for x in `find . -name "*.dupmark.bam" -not -name "*.yst.bam"` ; do bash BAM_RemoveDups.sh $x; done

##### load required modules
module add samtools
module add sambamba

##### set variables
BAMFILE=`echo $1`
NAME=`basename $BAMFILE .dupmark.bam`
annoDir="/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19"

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.RemoveDup
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=2G
#$ -pe shm 12

##################	commands
## remove low quality alignments
samtools view -F 1804 -f 2 -b $NAME.dupmark.bam > $NAME.nodup.bam
## index & flagstat the nodup BAMs
sambamba index -t 12 $NAME.nodup.bam
sambamba flagstat -t 12 $NAME.nodup.bam > $NAME.nodup.flagstat.qc
## sort the nodup BAMs by name
samtools sort -n $BAMFILE > $NAME.nmSort.bam
## remove intermediate files
#rm -f
EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh

