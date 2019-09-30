## How to Use:

**Before beginning, you need to install [HCP Workbench](https://www.humanconnectome.org/software/get-connectome-workbench) and ensure that _wb_command_ is on the PATH**

NOTE: if you are using the NIH Biowulf, run _module load connectome-workbench_ before running this code (this will load wb_command so it can be accessed on PATH).

1. git clone this repo and cd into the resulting directory
2. Download the HCP500 data release [here](https://db.humanconnectome.org/app/action/ChooseDownloadResources?project=HCP_Resources&resource=GroupAvg&filePath=HCP500_Parcellation_Timeseries_Netmats.zip)
3. Retrieve the restricted file from HCP1200 release (LINK)
4. You'll also need the restricted and the unrestricted (behavioral file) from the HCP500 release which is no longer distributed and we're not allowed to distribute it. Hopefully you have a copy somewhere.
4. Put all of these files in the repo directory

  Your folder structure should look like this
  
    HCP_Smith_et_al/
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
  
4. install the dependencies 
```
pip install -r requirements.txt
```
or 
```
conda create --no-default-packages -n HCP_Smith python=3.7 numpy=1.17.2 pandas=0.25.1
```
5. run _setup.sh_ (NOTE: You only need to run this once!)

  ```
  ./setup.sh <path_to_HCP500_Parcellation_Timeseries_Netmats.zip> <path_to_urls.txt> <path_to_HCP500_unrestricted_data> <path_to_HCP500_restricted_data> <path_to_HCP1200_restricted_data>"
  ```

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
    
6. run _hcp_cca_smith.m_

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
  <img src="https://github.com/Ngoyal95/HCP_CCA_Analysis/blob/master/analysis3/images/analysis3_VvsU.png">
</p>
<p align="Center">
    <img src="https://github.com/Ngoyal95/HCP_CCA_Analysis/blob/master/analysis3/images/analysis3_regression.png">
</p>

This plot is similar to the one from Smith et al., but still not exactly the same.
<p align="Center">
    <img src="https://github.com/Ngoyal95/HCP_CCA_Analysis/blob/master/images/smith_SMsvsConnectome.png">
</p>

## Variance analysis

The % variance of the connectome weights as explained by CCA mode 1 was also analyzed (in attempt to reproduce result from Smith et al.):
<p align="Center">
  <img src="https://github.com/Ngoyal95/HCP_CCA_Analysis/blob/master/variance_analyses/analysis3/images/analysis3_percentvariance_explained.png" width=450>
</p>

Although the % variance for mode 1 (approx 0.53%) agrees with what was reported in smith et al (see image below from the paper), the results for the other 19 CCA modes do not match up. This is likely because this variance analysis is just our guess as to how it was performed in Smith et al.

<p align="Center">
  <img src="https://github.com/Ngoyal95/HCP_CCA_Analysis/blob/master/images/smith_percentvar.png" width=450>
</p>
