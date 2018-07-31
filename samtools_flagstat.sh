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
#!/bin/bash -l
#SBATCH --job-name $NAME.flagstat
#SBATCH --output=$NAME.flagstat.out
#SBATCH --mail-user jchap14@stanford.edu
#SBATCH --mail-type=ALL
# Request run time & memory
#SBATCH --time=5:00:00
#SBATCH --mem=4G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH --account=mpsnyder

##### Run commands:
## get the flagstats
samtools flagstat $BAMFILE > $NAME.flagstats.qc

EOF

## qsub then remove the tempscript
sbatch $NAME.tempscript.sh #scg
sleep 1
rm $NAME.tempscript.sh

##### Extra commands to grab stats from all flagstat files (run interactive)
# for x in `find *.flagstats.qc`
# do
#     echo $x > $x.txt
#     cat $x | grep -e "total" -e "duplicates" -e "mapped" >> $x.txt
# done
