# auto-proc-pub
Automated data processing and publication workflows

## Contents:

### /scripts
Master scripts for two automated workflows. These scripts call on sub-routines located in ~/server/edi_151/scripts and ~/server/edi_253/scripts, and should be configured for, and run on your file server. In this example, the data processing and metadata generation occur on you computer, and the new data and metadata uploaded to your server for PASTA+ (the EDI Data Repository software) to download and update your data package.
1. update_time_series.R - Aggregate data, create metadata, upload to server, and update data package edi.151. 
2. update_derived_time_series.R - Use PASTA+ event notifications to automatically update data package edi.253 everytime edi.151 is updated. This script is under development.

### /server
Directories containing raw and processed data, metadata templates for generating EML metadata (create these files with the [EMLassemblyline R library](https://github.com/EDIorg/EMLassemblyline), and EML records.
