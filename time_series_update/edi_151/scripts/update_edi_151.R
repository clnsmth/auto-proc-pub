
# An example script demonstrating automated updates of time series data
# and upload to the Environmental Data Initiative Data Repository
#
# The following tasks are performed by this script:
# 1. Download raw time series data files from the project server
# 2. Aggregate raw data files into a single file
# 3. Run quality control checks on aggregated data
# 4. Download metadata templates configured for aggregated data from project server
# 5. Update the EML metadata file for the aggregated data
# 6. Upload the new EML file and aggregated data to the project server
# 7. Upload the new EML file and aggregated data to EDI




# Install and load libraries required by this workflow ------------------------

# Install and load CRAN packages

install.packages('devtools')
install.packages('stringr')
install.packages('ssh')

library(devtools)
library(stringr)
library(ssh)

# Install and load GitHub packages

devtools::install_github('EDIorg/EDIutils')
devtools::install_github('EDIorg/EMLassemblyline')

library(EDIutils)
library(EMLassemblyline)




# Parameterize this workflow --------------------------------------------------

# Identifier of EDI data package to update (e.g. 'edi.151'). Don't include a 
# revision number, one is automatically prescribed later. NOTE: A prior version 
# of this data package must exist in the EDI Data Repository. This is a 
# "revision" after all :) ... To upload the initial version of a data package, 
# use the EDI Data Portal https://portal.edirepository.org/nis/home.jsp) or 
# replace the EDIutils::api_update_data_package function (~ line 301) with 
# EDIutils::api_create_data_package

package.id <- 'edi.151'

# Name of project server that will be appended to user.serv (e.g. server.name = @some.server.org)

server.name <- '@colin.edirepository.org' 

# Path to raw data on project server

server.path.raw <- '/project/server/data/raw'

# Path to where processed data will be written on project server

server.path.processed <- '/project/server/data/processed'

# Path to metadata templates on project server

server.path.metadata.templates <- '/project/server/metadata_templateds'

# Path to where new EML will be written on project server

server.path.eml <- '/project/server/eml'

# Local path to where raw data will be written for further processing

local.path.raw <- '/project/local/data/raw'

# Local path to where raw data will be written for further processing

local.path.processed <- '/project/local/data/processed'

# Local path to where metadata templates will be written for EMLassemblyline access

local.path.metadata.templates <- '/project/local/metadata_templateds'

# Local path to where new EML will be written

local.path.eml <- '/project/local/eml'


# Begin workflow --------------------------------------------------------------

# Messages are used throughout this script to report on workflow status.

message(paste0('UPDATING DATA PACKAGE ', package.id))

# Enter user name and password of project server from which raw data are 
# downloaded, processed data are uploaded to, and from which the EDI Data 
# Repository will download the EML file and aggregated data file.

server.user.name <- readline('Enter server user name: ')
server.user.pass <- readline('Enter server user password: ')

# Enter user name, password, and affiliation for your EDI user account

pasta.user.name <- readline('Enter EDI user name: ')
pasta.user.pass <- readline('Enter EDI user password: ')
pasta.affiliation <- readline('Enter EDI user affiliation (LTER or EDI): ')

# Environment of EDI Data Repository to create the revision in. Can be:
# 'staging' (non-public and stable, good place for testing)
# 'production' (public and stable, final versions should be published here)

pasta.environment <- readline('Enter EDI environment to publish to (staging or production): ')




# Download raw time series data files from project server ---------------------

# Connect to project server

message('Connecting to server')

con <- ssh::ssh_connect(
  paste0(
    server.user.name, 
    '@',
    server.name
  ),
  passwd = server.user.pass
)

# Download raw data

message('Downloading raw data')

ssh::scp_download(
  session = con,
  files = server.path.raw,
  to = local.path.raw, 
  verbose = F
)




# Download metadata templates from project server -----------------------------

message('Downloading metadata template files')

ssh::scp_download(
  session = con,
  files = server.path.metadata.templates,
  to = local.path.metadata.templates, 
  verbose = F
)




# Aggregate the raw data files into a single file -----------------------------

# Read raw data files from local.path.raw (ADD YOUR DATA READING CODE HERE)

message('Reading raw data')

# Aggregate raw data (ADD YOUR DATA AGGREGATION CODE HERE)

message('Aggregating raw data')




# Run quality control checks on the aggregated data ---------------------------

# Run quality control (ADD YOUR QUALITY CONTROL CODE HERE)

message('Running quality control measures')

# Write aggregated and QC'd data to local.path.processed (ADD YOUR DATA WRITING CODE HERE)

message('Writing processed data to file')




# Update the EML metadata file for the aggregated data ------------------------

message('Creating new EML')

# Extract temporal coverage from data (NOTE: New temporal coverage needs to be
# added to the EML if the temporal coverage of the data change)

x <- read.csv(
  paste0(
    server.path.processed,
    '/taxa_photos.csv'
  )
)

new_temporal_coverage <- c(
  paste0(
    as.character(min(x$Year)), 
    '-01-01'
  ),
  paste0(
    as.character(max(x$Year)), 
    '-01-01'
  )
)

# Get new package revision number. Check the EDI Repository for the most recent
# revision number and add 1.

revision <- EDIutils::api_list_data_package_revisions(
  scope = stringr::str_remove(
    package.id,
    '\\.[:digit:]*$'
  ),
  identifier = stringr::str_extract(
    package.id,
    '[:digit:]*$'
  ),
  filter = 'newest',
  environment = pasta.environment
)

revision <- as.character(as.numeric(revision) + 1)

new_package_id <- paste0(package.id, '.', revision)

# Create EML metadata file

make_eml(
  path = local.path.metadata.templates,
  data.path = local.path.processed,
  eml.path = local.path.eml,
  dataset.title = 'McMurdo Sound, Antarctica: Cape Armitage, sponge abundance and cover and photo ID information: Raw data',
  data.files = c(
    "taxa_counts.csv", 
    "taxa_photos.csv"),
  data.files.description = c(
    'Benthic invertebrate photo metadata of McMurdo Sound, Antarctica',
    'Benthic invertebrates of McMurdo Sound, Antarctica'),
  data.files.url = server.path.processed,
  temporal.coverage = new_temporal_coverage,
  geographic.coordinates = c(
    '-77.859626',
    '166.702327',
    '-77.863072',
    '166.675889'),
  geographic.description = 'Cape Armitage, McMurdo Sound, Antarctica',
  maintenance.description = 'Ongoing',
  user.id = pasta.user.name,
  affiliation = pasta.affiliation,
  package.id = new_package_id
)




# Upload the aggregated data and the new EML file to the project server -------

message('Uploading new processed data and EML to server')

# Upload data tables

ssh::scp_upload(
  session = con,
  files = local.path.processed,
  to = server.path.processed, 
  verbose = F
)

# Upload EML file

ssh::scp_upload(
  session = con,
  files = paste0(
    local.path.eml,
    '/', 
    new_package_id, 
    '.xml'
  ),
  to = server.path.eml,
  verbose = F
)

# Disconnect from server

ssh::ssh_disconnect(con)




# Upload the new EML file and aggregated data to EDI --------------------------

EDIutils::api_update_data_package(
  path = local.path.eml,
  package.id = new_package_id,
  environment = pasta.environment,
  user.id = pasta.user.name,
  user.pass = pasta.user.pass,
  affiliation = pasta.affiliation
)

