# auto-proc-pub
Archiving data of an ongoing time series, or data derived from such a time series, requires standard processes that can be automated, thereby decreasing manual workload and improving accuracy and efficency. `auto-proc-pub` contains example automated data processing and archiving workflows using the [`Environmental Data Initiative (EDI) Data Repository`](https://portal.edirepository.org/nis/home.jsp) and the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline) and [`EDIutils`](https://github.com/EDIorg/EDIutils) R libraries.

## Contents:

### ~/scripts
Scripts for automated workflows, each of which calls on dataset specific files contained in ~/server.
1. `update_time_series.R` - Aggregates data, performs quality control, creates EML metadata, uploads to server, and archives EDI Data Package `edi.151`. 
2. `update_derived_time_series.R` - Uses PASTA+ event notifications to update data package `edi.253` everytime `edi.151` is updated. __This script is under development and not ready for use.__

### ~/server
Dataset directories containing the subdirectories:
* __~/data__ Data files
* __~/EML__ EML files output by `EMLassemblyline`
* __~/metadata_templates__ Metadata template files input to `EMLassemblyline`
* __~/scripts__ Scripts for running sub-processes (e.g. data QC, EML creation, upload to EDI, etc.)

### index.php
A script controlling server-side processing of the derived time series data package `edi.253`. This script is executed by event notifications sent to the server by the EDI Data Repository everytime `edi.151` is updated. __This script is under development and not ready for use.__
