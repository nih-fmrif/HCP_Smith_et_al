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
    ├── requirements.txt
  
4. install the dependencies (_pip install -r requirements.txt_)
5. run _setup.sh_
6. run _hcp_cca_smith.m_
