
# Script to update a derived time series and publish to EDI

# Load dependencies -----------------------------------------------------------

library(stringr)
library(dplyr)
library(XML)
library(EDIutils)
library(httr)
library(EMLassemblyline)
library(ssh)

# Parameterize ----------------------------------------------------------------

path_scripts <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\scripts'
usr_serv <- readline('Enter server user name: ')
pass_serv <- readline('Enter server password: ')
usr_pasta <- readline('Enter PASTA+ user name: ')
pass_pasta <- readline('Enter PASTA+ password: ')

message('\n\n')
message('================ UPDATING DATA PACKAGE "edi.253" ================\n\n')

# Create dataset --------------------------------------------------------------

source(paste0(path_scripts, '/data_create.R'))

# Create metadata -------------------------------------------------------------

source(paste0(path_scripts, '/metadata_create.R'))

# Upload data package to EDI --------------------------------------------------

source(paste0(path_scripts, '/package_upload.R'))

message('================ UPDATE COMPLETE ================================')
