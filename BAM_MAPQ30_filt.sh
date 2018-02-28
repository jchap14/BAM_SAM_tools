#!/bin/bash

##### Submit this script for CUT&RUN
## for x in `find . -name "*.bam" -not -name "*.yst.bam"` ; do bash BAM_MAPQ30_filt.sh $x; done

##### load required modules
module add samtools
module add sambamba

##### set variables
BAMFILE=`echo $1`
#NAME=`basename $BAMFILE .Aligned.sortedByCoord.out.bam`
NAME=`basename $BAMFILE .bam`
annoDir="/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19"

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.MAPQ30
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=1G
#$ -pe shm 12

##################	commands
## remove low quality alignments
samtools view -F 1804 -f 2 -q 30 -u $BAMFILE -o $NAME.filt.bam
## sort BAM by name
sambamba sort -t 12 -n $NAME.filt.bam -o $NAME.dupmark.bam
## fixmate BAMs
samtools fixmate -r $NAME.dupmark.bam $NAME.dupmark.bam.fixmate.bam
## remove low quality alignments
samtools view -F 1804 -f 2 -u $NAME.dupmark.bam.fixmate.bam -o $NAME.temp.bam
## sort by coordinate
sambamba sort -t 12 $NAME.temp.bam -o $NAME.q30.bam
## remove intermediate files
rm -f $NAME.dupmark.bam.fixmate.bam $NAME.dupmark.bam $NAME.temp.bam $NAME.filt.bam
EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh

