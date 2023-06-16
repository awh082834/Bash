## Included Scripts

|Script|Description|Usage|
|ashe_report_pdf.sh|Iterates of Ashe Pipeline output and creates PDF reports for each sample using an Rmd script|Usage: bash ashe_report_pdf.sh "outdir"|
|entrez_pull.sh|Obtains the taxonomy for NCBI accession numbers that is used for creating new MOB Suite plasmid databases|Usage: bash entrez_pull.sh "input_file" "ouput_file"|
|run_ashe.sh|Bash script used to run the Ashe Pipeline, an updated version of the ashe_report_pdf.sh, with an addition of the Nextflow command to run the pipeline and a sleep function to wait for the pipeline to finish |Usage: bash run_ashe.sh "input_sheet" "output_dir" "cpus" "memory" "optional -resume"|