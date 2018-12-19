
# An example automated workflow for updating and publishing time series data to 
# the EDI Data Repository.

# Load dependencies -----------------------------------------------------------

library(stringr)
library(dplyr)
library(EDIutils)
library(EMLassemblyline)
library(ssh)
library(httr)

# Parameterize ----------------------------------------------------------------

# User name and password for server from which EDI will download your data
usr_serv <- ''
pass_serv <- ''

# User name and password for EDI repository account
usr_pasta <- ''
pass_pasta <- ''

# Affiliation of EDI repo account. Can be 'EDI' or 'LTER'
affiliation <- 'EDI'

# Package to upload. Don't include a revision number. It is automatically prescribed in metadata_create.R
# NOTE: At least one version of this data package must be uploaded to the EDI repo for this
# Workflow to execute. Upload the first version of your data package through the EDI repo
# portal (https://portal.edirepository.org/nis/home.jsp) or replace the EDIutils::pkg_update 
# function (line 38 of '~/server/edi_151/package_upload.R') with EDIutils::pkg_create.
pkg_identifier <- 'edi.151'

# EDI repo environment to upload to. Can be 'development', 'staging', or 'production'
environment <- 'staging'

# Path to processing and upload scripts located at ~/server/edi_151/scripts. 
# NOTE: Each script contains a set of parameters that need to be defined for 
# your workflow.

path_scripts <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/scripts'

# Call processing, metadata, and upload scripts -------------------------------

message('\n\n')
message('================ UPDATING DATA PACKAGE "edi.151" ================\n\n')

# Aggregate data to publishable dataset ---------------------------------------

source(paste0(path_scripts, '/data_aggregate.R'))

# Create metadata -------------------------------------------------------------

source(paste0(path_scripts, '/metadata_create.R'))

# Upload data package to EDI --------------------------------------------------

source(paste0(path_scripts, '/package_upload.R'))

message('================ UPDATE COMPLETE ================================')
