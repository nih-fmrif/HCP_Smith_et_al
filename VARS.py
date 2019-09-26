#!/usr/bin/python3

import numpy as np
import pandas as pd
from pandas import DataFrame
from numpy import genfromtxt
import os
import sys
from pprint import pprint

cwd = os.getcwd()

column_headers_fp = sys.argv[1]
subject_ids_fp = sys.argv[2]
behavioral_data_fp = sys.argv[3]
restricted_data_fp = sys.argv[4]
rfMRI_data_fp = sys.argv[5]
varsQconf_fp = sys.argv[6]

# get the column headers, and names of subjects
column_headers = [line.rstrip('\n') for line in open(column_headers_fp)]
subjects = [line.rstrip('.pconn.nii\n') for line in open(subject_ids_fp)]

# now import "behavioral" and "restricted" datasets into Pandas dataframes
behavioral_data = pd.read_csv(behavioral_data_fp)
restricted_data = pd.read_csv(restricted_data_fp)

# filter the behavioral and restricted datasets to contain only the relevant 461 subject data
behavioral_data = behavioral_data[behavioral_data['Subject'].isin(subjects)]
restricted_data = restricted_data[restricted_data['Subject'].isin(subjects)]

# Now import the rfMRI and quarter/release (varsQconf) data
varsqconf = pd.read_csv(varsQconf_fp, names=['quarter/release'])
rfmri = pd.read_csv(rfMRI_data_fp, sep=" ", names=['rfmri_motion'])

# reindex so that the varsqconf has the correct subject IDs as its row labels
varsqconf.index = rfmri.index

# concatenate the rfMRI and varsQconf data (we will need to do this later anyway)
rfmri_varsqconf = pd.concat([rfmri, varsqconf], axis=1)

# get the names of column headers
behav_headers=list(behavioral_data.columns.values)
restrict_headers=list(restricted_data.columns.values)
# Make lowercase
column_headers=[element.lower() for element in column_headers]
behav_headers=[element.lower() for element in behav_headers]
restrict_headers=[element.lower() for element in restrict_headers]

# Now let's lets get the column names that are overlapped in each
overlap_in_behav = np.intersect1d(column_headers,behav_headers)
overlap_in_restrict = np.intersect1d(column_headers,restrict_headers)

# Now pull out the columns and their data
# first we will need to convert all the column headers to lowercase
behavioral_data.columns = behavioral_data.columns.str.lower()
restricted_data.columns = restricted_data.columns.str.lower()
behavioral_data_filtered_cols = behavioral_data[overlap_in_behav]
restricted_data_filtered_cols = restricted_data[overlap_in_restrict]

# concat the dataframes
# first reindex all of them to match rfmri_varsqconf
behavioral_data_filtered_cols.index = rfmri_varsqconf.index
restricted_data_filtered_cols.index = rfmri_varsqconf.index

vars = pd.concat([behavioral_data_filtered_cols, restricted_data_filtered_cols, rfmri_varsqconf], axis = 1)

vars = vars.reindex(columns = column_headers)
vars.reset_index(level=0, inplace=True) # get rid of the index for compatibility w/ MATLAB, instead make subject id's in new column called 'subject'
vars = vars.drop(columns='subject id')
vars.columns.values[0]='subject' #rename

print("Size of resulting vars matrix: ", vars.shape)
vars.to_csv("VARS500.txt", index=False)