
# Script to update a derived time series and publish to EDI

# Load dependencies -----------------------------------------------------------

suppressWarnings(library(stringr))
suppressWarnings(library(dplyr))
suppressWarnings(library(XML))
suppressWarnings(library(EDIutils))
suppressWarnings(library(httr))
suppressWarnings(library(EMLassemblyline))
suppressWarnings(library(ssh))

# Parameterize ----------------------------------------------------------------

path.scripts <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/scripts'

# message('\n\n')
# message('================ UPDATING DATA PACKAGE "edi.253" ================\n\n')

# Create dataset --------------------------------------------------------------

source(paste0(path.scripts, '/data_create.R'))

# Create metadata -------------------------------------------------------------

source(paste0(path.scripts, '/metadata_create.R'))

# Upload data package to EDI --------------------------------------------------

source(paste0(path.scripts, '/package_upload.R'))

# message('================ UPDATE COMPLETE ================================')

