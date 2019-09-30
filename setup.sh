#! /bin/bash

# analysis1_vars_and_NET - A script to set up files/folders for running reproduced analysis by Smith et al.

# Example use:
# setup.sh


##### Functions
usage()
{
	echo "usage: setup.sh <path_to_HCP500_Parcellation_Timeseries_Netmats.zip> <path_to_urls.txt> <path_to_HCP500_unrestricted_data> <path_to_HCP500_restricted_data> <path_to_HCP1200_restricted_data>"
}


#### Setup stuff
while getopts h option
do
	case "${option}"
	in
		h) usage
	esac
done

echo "Setting up folder structure..."
PTN=$1 #HCP500 PTN data (zip file)
URLS=$2
BEHAV500=$3
RESTR500=$4
RESTR1200=$5
ICA=200

# Set up directory structure
mkdir data images other mat_files

# pull necessary files from online (column_headers.txt, rfMRI_motion, varsQconf (quarter/release))
if($(type wget &> /dev/null)) then
	# use wget
	wget -q -i $URLS
elif ($(type curl &> /dev/null )) then
	xargs -n 1 curl -s -O < $URLS
else
	echo "Neither wget nor curl is installed, please install either one. Script terminating."
	echo
	exit 1
fi

# move files
mv column_headers.txt rfMRI_motion.txt varsQconf.txt data/
# mv column_headers.txt data/
# mv rfMRI_motion.txt data/
# mv varsQconf.txt data/
SMs=data/column_headers.txt
RFMRI=data/rfMRI_motion.txt
VARSQCONF=data/varsQconf.txt

# unzip the HCP500_Parcellation_Timeseries_Netmats.zip
echo "Extracting HCP500_Parcellation_Timeseries_Netmats.zip to ./other/"
unzip -qq $PTN -d other
tar -xzf other/HCP500_Parcellation_Timeseries_Netmats/netmats_3T_Q1-Q6related468_MSMsulc_ICAd200_ts2.tar.gz
# CIFTI=other/HCP500_Parcellation_Timeseries_Netmats/netmats/3T_Q1-Q6related468_MSMsulc_d200_ts2_netmat2/
CIFTI=netmats/3T_Q1-Q6related468_MSMsulc_d200_ts2_netmat2/

### convert the CIFTI files to text files, generate NET, then generate vars
epoch=$(date +%s) # use unix epoch time

# Make directory for the .txt files
if [ ! -d ${CIFTI}/txt_files_${epoch} ]; then
  mkdir -p ${CIFTI}/txt_files_${epoch};
fi

# find $CIFTI -name "*.pconn.nii" -execdir echo {} ';' | sort -n > $CIFTI/file_names.txt
ls $CIFTI*.pconn.nii | xargs -n 1 basename > $CIFTI/file_names.txt

file_names=$CIFTI/file_names.txt
NUMSUBS=$(find $CIFTI -name "*.pconn.nii" -execdir echo {} ';' | wc -l)

read -p "Create NET from ${NUMSUBS} matrices, proceed? [y/n]: " -n 1 -r
echo    # (optional) move to a new line
echo "Converting CIFTI files to .txt..."
if [[ $REPLY =~ ^[Yy]$ ]]
then
	while read p; do
		fname=$(echo $p | grep -o '^[^.]\+')
		loadfile=$CIFTI/$p
		outfile=${CIFTI}/txt_files_${epoch}/$fname.txt
		# Assumes wb_command is on PATH
		wb_command -cifti-convert -to-text $loadfile $outfile -col-delim , # use hcp workbench tool wb_command to convert CIFTI --> txt files
	done < $file_names

	# Generate NET
	echo "CIFTI to .txt conversions complete, now generating HCP500 NET file..."
	python NET.py ${CIFTI}/txt_files_${epoch} $ICA $NUMSUBS

	echo "Fixing HCP500 restricted file, imputing missing Father_ID data for subjects (108525, 116322, 146331, 256540) using data from HCP1200..."
	./restricted_file_update.sh $RESTR500 $RESTR1200

	# Generate vars
	echo "Now creating subject measures matrix 'vars'..."
	python VARS.py $SMs $file_names $BEHAV500 restricted_500_modified.csv $RFMRI $VARSQCONF

	mv $BEHAV500 $RESTR500 $RESTR1200 restricted_500_modified.csv VARS500.txt NET500.txt data/
	mv netmats/ other/
fi

echo "Complete!"