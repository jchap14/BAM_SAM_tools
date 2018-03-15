#!/bin/bash

##### Submit this script for CUT&RUN
## for x in `find . -name "*.q30.bam" -not -name "*.yst.bam"` ; do bash Picard-MarkDuplicates.sh $x; done

##### set variables
BAMFILE=`echo $1`
NAME=`basename $1 .q30.bam`

##### load required modules
module add picard-tools

##### create a tempscript for queue sub
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.markDup
#$ -j y
#$ -V
#$ -cwd
#$ -l h_vmem=25G
#$ -pe shm 1
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

java -Xms256M -Xmx4G -XX:ParallelGCThreads=1 -jar \
/srv/gsfs0/software/picard-tools/1.129/picard.jar \
MarkDuplicates INPUT=$BAMFILE OUTPUT=$NAME.dupmark.bam \
METRICS_FILE=$NAME.deDup.metrics VALIDATION_STRINGENCY=LENIENT \
ASSUME_SORTED=true REMOVE_DUPLICATES=false
# rm $NAME.deDup.bam
EOF

## submit tempscript & cleanup
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
