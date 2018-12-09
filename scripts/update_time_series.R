
# Script to update and publish time series data

# Load dependencies -----------------------------------------------------------

suppressWarnings(library(stringr))
suppressWarnings(library(dplyr))
suppressWarnings(library(EDIutils))
suppressWarnings(library(EMLassemblyline))
suppressWarnings(library(ssh))
suppressWarnings(library(httr))

# Parameterize ----------------------------------------------------------------

path_scripts <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/scripts'
usr_serv <- readline('Enter server user name: ')
pass_serv <- readline('Enter server password: ')
usr_pasta <- readline('Enter PASTA+ user name: ')
pass_pasta <- readline('Enter PASTA+ password: ')

message('\n\n')
message('================ UPDATING DATA PACKAGE "edi.151" ================\n\n')

# Aggregate data to publishable dataset ---------------------------------------

source(paste0(path_scripts, '/data_aggregate.R'))

# Create metadata -------------------------------------------------------------

source(paste0(path_scripts, '/metadata_create.R'))

# Upload data package to EDI --------------------------------------------------

source(paste0(path_scripts, '/package_upload.R'))

message('================ UPDATE COMPLETE ================================')
