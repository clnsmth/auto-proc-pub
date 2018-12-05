
# "Update derived time series" - Automatically update a derived time series 
# data package in the Environmental Data Initiative Repository when a new 
# revision of the parent data package is created.
#
# - Load required R libraries
# - Update parent data package
# - Validate parent formatting
# - Revision child and upload

# Load dependencies -----------------------------------------------------------

rm(list = ls())
library(EDIutils)
library(EMLassemblyline)
library(ssh)

# Parameterize ----------------------------------------------------------------

path_local <- "C:\\Users\\Colin\\Desktop\\sandbox"
path_remote <- '/var/www/lter/sites/default/files/data/edi/tests'
usr_serv <- readline('Enter server user name: ')
pass_serv <- readline('Enter server password: ')
pass_pasta <- readline('Enter PASTA+ password: ')

# Download from server --------------------------------------------------------

con <- ssh::ssh_connect(
  'csmith@lter.limnology.wisc.edu',
  passwd = pass_serv)

ssh::scp_download(
  session = con,
  files = path_remote,
  to = path_local
)

# Process data ----------------------------------------------------------------

# Load
# Process
# Write

# Make metadata ---------------------------------------------------------------

# Upload to server ------------------------------------------------------------

ssh::scp_upload(
  session = con,
  files = paste0(path_local, '/tests/data/production'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/data/production'
)

ssh_disconnect(con)

# Evaluate/upload to EDI's Data Repository ------------------------------------
