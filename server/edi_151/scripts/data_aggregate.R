
# Aggregate raw data and write to file

message('*** AGGREGATING DATA ***')

# Load dependencies -----------------------------------------------------------

library(stringr)
library(dplyr)

# Parameterize ----------------------------------------------------------------

path_raw <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_151\\data\\raw'
path_processed <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_151\\data\\processed'

# Read data -------------------------------------------------------------------

message('Reading data')

files_raw <- list.files(path_raw)
files_counts <- files_raw[stringr::str_detect(files_raw, 'taxa_counts')]
files_photos <- files_raw[stringr::str_detect(files_raw, 'taxa_photos')]

# Aggregated data -------------------------------------------------------------

message('Binding rows')

counts <- lapply(paste0(path_raw, '/', files_counts), read.csv, as.is = TRUE)
counts <- dplyr::bind_rows(counts)

photos <- lapply(paste0(path_raw, '/', files_photos), read.csv, as.is = TRUE)
photos <- dplyr::bind_rows(photos)

# Write data to file ----------------------------------------------------------

message('Writing to file')

write.csv(counts, paste0(path_processed, '/taxa_counts.csv'), row.names = FALSE)
write.csv(photos, paste0(path_processed, '/taxa_photos.csv'), row.names = FALSE)

message('*** DONE ***\n\n')
