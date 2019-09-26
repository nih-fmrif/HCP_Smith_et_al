#! /bin/bash

# Bash script to update HCP500, imputing missing Father_ID data, using HCP1200 data

RESTR500=$1
RESTR1200=$2

cp $RESTR500 restricted_500_modified.csv # make copy

RESTR500_M=restricted_500_modified.csv

# Get the column IDs for 'Father_ID' field in both datafiles
col_500=$(awk -v RS=',' '/Father_ID/{print NR; exit}' $RESTR500)
col_1200=$(awk -v RS=',' '/Father_ID/{print NR; exit}' $RESTR1200)

subs=(108525 116322 146331 256540)

for i in "${subs[@]}"
do
	:
	# Pull the correct data from HCP1200 restricted file
	sub_1200=$(awk -v name="$i" '$1 ~ name' $RESTR1200) # get the row for one subject
	value=$(echo $sub_1200 | awk -v col="$col_1200" -F "," '{ print $col }')

	# Now find the correct row ID in HCP500 to replace
	row=$(awk -v name="$i" -F RS='\n' '$1 ~ name {print NR; exit}' $RESTR500)
	
	# Now replace the value in HCP500
	# https://stackoverflow.com/questions/21418748/insert-a-string-number-into-a-specific-cell-of-a-csv-file
	awk -v value=$value -v row=$row -v col=$col_500 'BEGIN{FS=OFS=","} NR==row {$col=value}1' $RESTR500_M > temp.csv && mv temp.csv $RESTR500_M
done