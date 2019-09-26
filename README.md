## How to Use:

1. Download the HCP500 data release [here](https://db.humanconnectome.org/app/action/ChooseDownloadResources?project=HCP_Resources&resource=GroupAvg&filePath=HCP500_Parcellation_Timeseries_Netmats.zip)
2. Download the restricted_500, restricted_1200, and unrestricted_500 files from our Box account
3. pull this github repo

  Your folder structure should look like this
  
    analysis/
    ├── HCP500_Parcellation_Timeseries_Netmats.zip
    ├── restricted_500_release.csv
    ├── restricted_1200_release.csv
    ├── unrestricted_500_release.csv
    ├── setup.sh
    ├── restricted_file_update.sh
    ├── NET.py
    ├── VARS.py
    ├── urls.txt
    └── requirements.txt
  
4. install the dependencies (_pip install -r requirements.txt_)
5. run _setup.sh_

  After running, your directory structure should look like this:
  
    analysis/
    ├── images/
    ├── mat_files/
    ├── other/
    │   ├── HCP500_Parcellation_Timeseries_Netmats/     # Extracted version of HCP500_Parcellation_Timeseries_Netmats.zip
    ├── data/                                            # Contains data necessary for analysis
    │   ├── column_headers.txt
    │   ├── NET500.txt
    │   ├── restricted_500_modified.csv
    │   ├── restricted_500_release.csv
    │   ├── restricted_1200_release.csv
    │   ├── rfMRI_motion.txt
    │   ├── unrestricted_500_release.csv
    │   ├── VARS500.txt
    │   ├── varsQconf.txt
    ├── HCP500_Parcellation_Timeseries_Netmats.zip
    ├── setup.sh
    ├── restricted_file_update.sh
    ├── NET.py
    ├── VARS.py
    ├── urls.txt
    └── requirements.txt
    
6. run _hcp_cca_smith.m_ (NOTE: before running, make sure to add the _data/_ folder to your MATLAB path)

## Output
**Data used:**
  - HCP500 behavioral and restricted datasets
  - HCP500 netmats
  - varsQconf
  - rfMRI
  - list of 478 SMs
  
**Results:**
  - 461 subjects
  - Ncca (number of FWE-significant CCA components): 0
  - Scatter plot of SM weights vs. connectome weights:
<p align="Center">
  <img src="images/VvsU.png">
</p>
<p align="center">
    <img src="images/VvsU_regression.png">
</p>

This plot is similar to the one from Smith et al., but still not exactly the same.

## Variance analysis

The % variance of the connectome weights as explained by CCA mode 1 was also analyzed (in attempt to reproduce result from Smith et al.):
<p align="Center">
  <img src="images/percentvariance_explained.png" width=450>
</p>

Although the % variance for mode 1 (approx 0.53%) agrees with what was reported in smith et al (see image below from the paper), the results for the other 19 CCA modes do not match up. This is likely because this variance analysis is just our guess as to how it was performed in Smith et al.

<p align="Center">
  <img src="images/smith_percentvar.png" width=450>
</p>
