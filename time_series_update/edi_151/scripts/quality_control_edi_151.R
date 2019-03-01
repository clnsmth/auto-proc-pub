# This script performs the following tasks:
# 1. Download raw time series data files from project server
# 2. Aggregate the raw data files into a single file
# 3. Run quality control checks on the aggregated data

# Execute this script ---------------------------------------------------------

# Connect to project server

con <- ssh::ssh_connect(
  paste0(
    server.user.name, 
    '@',
    server.name
  ),
  passwd = server.user.pass
)

# Download raw time series data

ssh::scp_download(
  session = con,
  files = c(
    '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/data/processed/taxa_photos.csv',
    '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/data/processed/taxa_counts.csv'
  ),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_151/data/processed', 
  verbose = F
)

# Read data -------------------------------------------------------------------

message('Reading data')

files_raw <- list.files(server.path.raw)
files_counts <- files_raw[stringr::str_detect(files_raw, 'taxa_counts')]
files_photos <- files_raw[stringr::str_detect(files_raw, 'taxa_photos')]

# Aggregated data -------------------------------------------------------------

message('*** AGGREGATING DATA ***')

message('Binding rows')

counts <- lapply(paste0(server.path.raw, '/', files_counts), read.csv, as.is = TRUE)
counts <- dplyr::bind_rows(counts)

photos <- lapply(paste0(server.path.raw, '/', files_photos), read.csv, as.is = TRUE)
photos <- dplyr::bind_rows(photos)

# Write data to file ----------------------------------------------------------

message('Writing to file')

write.csv(counts, paste0(server.path.processed, '/taxa_counts.csv'), row.names = FALSE)
write.csv(photos, paste0(server.path.processed, '/taxa_photos.csv'), row.names = FALSE)

message('*** DONE ***\n\n')
