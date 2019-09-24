#! /bin/bash

# Bash script to update HCP500, imputing missing Father_ID data, using HCP1200 data

RESTR500=$1
RESTR1200=$2

cp $RESTR500 restricted_500_modified.csv # make copy

RESTR500M=restricted_500_modified.csv

# Get the column IDs for 'Father_ID' field in both datafiles
F_ID_col_500=$(awk -v RS=',' '/Father_ID/{print NR; exit}' $RESTR500M)
F_ID_col_1200=$(awk -v RS=',' '/Father_ID/{print NR; exit}' $RESTR1200)

subs=(108525 116322 146331 256540)

for i in "${subs[@]}"
do
	:
	# Pull the correct data from HCP1200 restricted file
	sub_1200=$(awk -v name="$i" '$1 ~ name' $RESTR1200) # get the row for one subject
	value=$(echo $sub_1200 | awk -v col="$F_ID_col_1200" -F "," '{ print $col }')

	# Now find the correct row ID in HCP500 to replace
	RID=$(awk -v name="$i" -F RS='\n' '$1 ~ name {print NR; exit}' $RESTR500M)
	
	# Now replace the value in HCP500
	# https://stackoverflow.com/questions/21418748/insert-a-string-number-into-a-specific-cell-of-a-csv-file
	awk -v value=$value -v row=$RID -v col=$F_ID_col_500 'BEGIN{FS=OFS="@"} NR==row {$col=value}1' $RESTR500M
	# awk -v name="$i" -v col="$F_ID_col_500" -v val="$F_ID_Val" -F, '$1 ~name {$col=$val}' $RESTR500M
	# awk -v r="$RID" -v c="$F_ID_col_500" -v val="$F_ID_Val" -F, 'BEGIN{OFS=","}; NR != r; NR == r {$c = val}' $RESTR500M
	# awk -v r=$RID -v c=$F_ID_col_500 -v val=$F_ID_Val -F, 'BEGIN{OFS=","}; NR != r; NR == r {$c = val}' $RESTR500M
done

# # replace data in one cel
# nawk -v r=2 -v c=3 -v val=5 -F, 'BEGIN{OFS=","}; NR != r; NR == r {$c = val; print}' mydata