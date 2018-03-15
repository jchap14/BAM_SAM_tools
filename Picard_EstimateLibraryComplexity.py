## fix this to batch later if desired

INPUT='MEK5_KLF4_sc.sorted.bam'
NAME=`basename $INPUT .sorted.bam`
module load java picard-tools
java -jar /srv/gsfs0/software/picard-tools/2.13.2/picard.jar EstimateLibraryComplexity I=$INPUT O=$NAME.lib_complex_metrics.txt VERBOSITY=ERROR