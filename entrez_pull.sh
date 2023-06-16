#!bin/bash

file=$1
outfile=$2
touch plasmid_multifasta.fasta
touch plas_host_taxon.txt
touch tax_id_only.txt
touch names.txt
for next in $(cat $file); do 
	echo $next
	esearch -db nucleotide -query "$next" | efetch -format fasta >> plasmid_multifasta.fasta
	esummary -db nuccore -id "$next" | xtract -pattern DocumentSummary -element Caption, TaxId >> plas_host_taxon.txt
done

while IFS='	' read -r col1 col2
do 
	echo $col2 >> tax_id_only.txt
done <plas_host_taxon.txt

for next in $(cat tax_id_only.txt); do
	echo $next
	efetch -db taxonomy -id "$next" -format xml | xtract -pattern Taxon -element TaxId,ScientificName >> names.txt
	sleep 2
done 

python /opt/efs/AWH_dev/scripts/python/combine_id_taxon.py plas_host_taxon.txt names.txt $outfile
rm -rf names.txt plas_host_taxon.txt tax_id_only.txt

