# auto-proc-pub
Archiving data of an ongoing time series, or data derived from such a time series, requires standard processes that can be automated, thereby decreasing manual workload and improving accuracy and efficency. `auto-proc-pub` contains example automated data processing and archiving workflows using the [`Environmental Data Initiative (EDI) Data Repository`](https://portal.edirepository.org/nis/home.jsp) and the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline) and [`EDIutils`](https://github.com/EDIorg/EDIutils) R libraries.

## Contents:

* [Time series update](#time-series-update)
* [Derived time series update](#derived-time-series-update)

### Time series update

Example workflow for time series data in which the following tasks are performed:

1. Download raw time series data files from project server
2. Aggregate raw data files into a single file
3. Run quality control checks on aggregated data
4. Download metadata templates configured for aggregated data from project server
5. Update the EML metadata file for the aggregated data
6. Upload the new EML file and aggregated data to the project server
7. Upload the new EML file and aggregated data to EDI

To run this example save the script `~/time_series_update/edi_151/scripts/update_edi_151.R` to your local workspace, upload the directory `~/time_series_update` to your server, then follow instructions in `update_edi_151.R` to configure this script for your own testing. NOTE: You will need an EDI Data Repository account to run this workflow. Contact `info@environmentaldatainitiative.org` to get one.

Contents of `~/time_series_update`
* __/data__ Raw and processed data files
* __/EML__ EML files output by the workflow
* __/metadata_templates__ Metadata template files configured for the processed data
* __/scripts__ Scripts for running this workflow

### Derived time series update

Uses PASTA+ event notifications to update data package `edi.253` everytime `edi.151` is updated. __This workflow is under development and not ready for use.__
