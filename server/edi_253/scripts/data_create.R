
# Get parent data from EDI, process, and write to file

message('*** CREATING DERIVED DATA ***')

# Load dependencies -----------------------------------------------------------

library(stringr)
library(dplyr)
library(XML)
library(EDIutils)

# Parameterize ----------------------------------------------------------------

pkg_identifier <- 'edi.151' # parent package scope and ID
environment <- 'staging'
# path_raw <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_151\\data\\raw'
# path_processed <- 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_151\\data\\processed'

# Read parent data ------------------------------------------------------------

message('Reading data')

# Get newest package ID

pkg_id <- stringr::str_replace_all(pkg_identifier, '\\.', '/')
r <- httr::GET(url = paste0(EDIutils::url_env(environment), 
                            '.lternet.edu/package/eml/', 
                            pkg_id, '?filter=newest'))
revision <- httr::content(r, encoding = 'UTF-8')
package_id <- paste0(pkg_identifier, '.', revision)

metadata <- xmlParse(paste0('https://pasta-s',
                            ".lternet.edu/package/metadata/eml/",
                            str_replace_all(package_id, '\\.', '/')),
                     isHTML = F)

# Table names

entity_names <- unlist(
  xmlApply(metadata["//dataset/dataTable/entityName"], 
           xmlValue)
)

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
