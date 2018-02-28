#!/bin/bash

##### Submit this script for CUT&RUN
## for x in `find . -name "*.bam" -not -name "*.yst.bam"` ; do bash samtools_index_stats.CnR.sh $x; done

##### NOTE: flagstat #'s are for single end reads & include secondary mappings

##### load required modules
module add samtools
module add rseqc

##### set variables
BAMFILE=`echo $1`
NAME=`basename $BAMFILE .Aligned.sortedByCoord.out.bam`
# NAME=`basename $BAMFILE .bam`
annoDir="/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19"

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.Index_Stat
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=1G
#$ -pe shm 12

## index the BAM
samtools index $BAMFILE

## get the total number of alignments
samtools flagstat $BAMFILE > $NAME.flagstats.txt

## get the total number of alignments to chrM
samtools idxstats $BAMFILE > $NAME.idx_stats.txt

## join the stats into "bam_stats.txt"
echo $BAMFILE >> BAMstats.txt
cat $NAME.flagstats.txt | egrep "total" >> BAMstats.txt
cat $NAME.idx_stats.txt | egrep "chrM"  >> BAMstats.txt

## remove the extra files
rm $NAME.flagstats.txt $NAME.idx_stats.txt

## run split_bam.py to determine rRNA alignments in BAM
# echo "STARTING split_bam.py" 
# split_bam.py -i $BAMFILE -r $annoDir/hg19_rRNA.bed -o $NAME
# rm $NAME.junk.bam $NAME.ex.bam $NAME.in.bam
EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
