
# Get parent data from EDI, process, and write to file

message('*** CREATING DERIVED DATA ***')

# Load dependencies -----------------------------------------------------------

library(stringr)
library(dplyr)
library(XML)
library(EDIutils)
library(httr)

# Parameterize ----------------------------------------------------------------

pkg_identifier <- 'edi.151' # parent package scope and ID
environment <- 'staging'
affiliation <- 'LTER'
# path_raw <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_151\\data\\raw'
path_processed <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\data'

# Read parent data ------------------------------------------------------------

message('Reading data')

# Get newest package ID

pkg_id <- stringr::str_replace_all(pkg_identifier, '\\.', '/')
r <- httr::GET(url = paste0(EDIutils::url_env(environment), 
                            '.lternet.edu/package/eml/', 
                            pkg_id, '?filter=newest'))
revision <- httr::content(r, encoding = 'UTF-8')
package_id <- paste0(pkg_identifier, '.', revision)

# Get data identifiers

sir <- stringr::str_replace_all(package_id, '\\.', '/')

r <- httr::GET(url = paste0(EDIutils::url_env(environment), 
                            '.lternet.edu/package/name/eml/', 
                            sir))
files <- suppressMessages(httr::content(r, type = 'text/csv', encoding = 'UTF-8'))
files <- as.data.frame(files)
files <- data.frame(id = c(colnames(files)[1], files[ , 1]),
                    name = c(colnames(files)[2], files[ , 2]),
                    stringsAsFactors = FALSE)

# Read data

use_i <- files$name == 'taxa_counts.csv'
counts <- read.csv(
  paste0(EDIutils::url_env(environment), '.lternet.edu/package/data/eml/', sir, 
         '/', files$id[use_i]),
  as.is = TRUE)

use_i <- files$name == 'taxa_photos.csv'
photos <- read.csv(
  paste0(EDIutils::url_env(environment), '.lternet.edu/package/data/eml/', sir, 
         '/', files$id[use_i]),
  as.is = TRUE)

# Process data ----------------------------------------------------------------

message('Applying Quality Control methods')

# counts <- lapply(paste0(path_raw, '/', files_counts), read.csv, as.is = TRUE)
# counts <- dplyr::bind_rows(counts)
# 
# photos <- lapply(paste0(path_raw, '/', files_photos), read.csv, as.is = TRUE)
# photos <- dplyr::bind_rows(photos)

# Write data to file ----------------------------------------------------------

message('Writing to file')

write.csv(counts, paste0(path_processed, '/taxa_counts_qcd.csv'), row.names = FALSE)
write.csv(photos, paste0(path_processed, '/taxa_photos_qcd.csv'), row.names = FALSE)

message('*** DONE ***\n\n')
