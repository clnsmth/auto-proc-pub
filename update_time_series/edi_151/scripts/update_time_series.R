
# Automated workflow containing these steps:
# - Download data from server
# - Download new data and metadata templates from server
# - Append new data
# - Apply quality control measures
# - Make metadata
# - Upload data and metadata to server
# - Evaluate/upload to EDI's Data Repository

# Load dependencies -----------------------------------------------------------

rm(list = ls())
library(EDIutils)
library(EMLassemblyline)
library(ssh)
library(httr)

# Parameterize ----------------------------------------------------------------

path_local <- "C:\\Users\\Colin\\Desktop\\sandbox"
path_remote <- '/var/www/lter/sites/default/files/data/edi/tests'
usr_serv <- readline('Enter server user name: ')
pass_serv <- readline('Enter server password: ')
usr_pasta <- readline('Enter PASTA+ user name: ')
pass_pasta <- readline('Enter PASTA+ password: ')
environment <- 'staging'
package.identifier <- 'edi.151'
affiliation <- 'LTER'

# Download from server --------------------------------------------------------

con <- ssh::ssh_connect(
  paste0(usr_serv, '@lter.limnology.wisc.edu'),
  passwd = pass_serv
)

ssh::scp_download(
  session = con,
  files = path_remote,
  to = path_local
)

# Process data ----------------------------------------------------------------

base::source(paste0(path_local, '/tests/edi_151/scripts/process_data.R'))
process_data(data = 'test', new.data = 'test2')

# Make metadata ---------------------------------------------------------------

base::source(paste0(path_local, '/tests/edi_151/scripts/create_metadata.R'))

# Upload to server ------------------------------------------------------------

# data
ssh::scp_upload(
  session = con,
  files = paste0(path_local, '/tests/edi_151/data'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_151'
)

# EML
ssh::scp_upload(
  session = con,
  files = paste0(path_local, '/tests/edi_151/eml'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_151'
)

ssh_disconnect(con)

# Evaluate/upload to EDI's Data Repository ------------------------------------

# EDIutils::pkg_update()

