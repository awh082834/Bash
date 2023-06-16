#!/bin/bash
input=$1
outdir=$2
cpus=$3
mem=$4
resume=$5

file_to_wait="$outdir"/LR_report.csv

nextflow run /opt/efs/AWH_dev/scripts/nfCore/dcls-ashe/dcls-ashe/main.nf --input $input --outdir $outdir --polish_db /opt/efs/AWH_dev/databases/bacteria.msh.gz --ectyper_db /opt/efs/AWH_dev/databases/refseq.genomes.k21s1000.msh.gz --mash_db /opt/efs/AWH_dev/databases/RefSeqSketchesDefaults.msh.gz -profile docker --max_cpus $cpus --max_memory $mem

while [! -e ${file_to_wait}]
do
	sleep 1
done

echo "Ashe is finished, PDF reports will now write using $outdir"

for file in "$outdir"/characterization/amrfinder/*.tsv;
do
	sample_name=${file%.tsv}
	sample_name=${sample_name##*/}
	echo $sample_name
	amr_file="$outdir"/characterization/amrfinder/"$sample_name".tsv
	echo $amr_file
	bandage_file="$outdir"/bandage/"$sample_name".png
	echo $bandage_file
	metrics="$outdir"/LR_report.csv
	echo $metrics
	plasmid="$outdir"/characterization/mobRecon/"$sample_name"/mobtyper_results.txt
	echo $plasmid
	Rscript -e "rmarkdown::render(\"/opt/efs/AWH_dev/scripts/nfCore/dcls-ashe/dcls-ashe/bin/test.Rmd\",knit_root_dir = \"$outdir\", intermediates_dir = \"$outdir\", output_file=\"$sample_name.pdf\", output_dir=\"$outdir\",params=list(amr=\"$amr_file\", bandage=\"$bandage_file\",metrics=\"$metrics\",plasmid=\"$plasmid\",sample=\"$sample_name\",workDir=\"$outdir\"))"
done

