
# Get parent data from EDI, process, and write to file

# message('*** CREATING DERIVED DATA ***')

# Parameterize ----------------------------------------------------------------

pkg_identifier <- 'edi.151' # parent package scope and ID
environment <- 'staging'
affiliation <- 'LTER'
path_processed <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/data'

# Read parent data ------------------------------------------------------------

# message('Reading data')

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

# Randomly assign QC flags to data (a simulation of actual QC procedures)

# message('Applying Quality Control methods')

counts$Area_flag <- rep(NA_character_, nrow(counts))
counts$Area_flag[sample(nrow(counts), 10)] <- 'A'
counts$Area_flag[sample(nrow(counts), 10)] <- 'B'
counts$PctCov_flag <- rep(NA_character_, nrow(counts))
counts$PctCov_flag[sample(nrow(counts), 10)] <- 'C'
counts$PctCov_flag[sample(nrow(counts), 10)] <- 'D'
counts$Count_flag <- rep(NA_character_, nrow(counts))
counts$Count_flag[sample(nrow(counts), 10)] <- 'E'
counts$Count_flag[sample(nrow(counts), 10)] <- 'F'

photos$Depth_flag <- rep(NA_character_, nrow(photos))
photos$Depth_flag[sample(nrow(photos), 10)] <- 'G'
photos$Depth_flag[sample(nrow(photos), 10)] <- 'H'
photos$PhotoArea_flag <- rep(NA_character_, nrow(photos))
photos$PhotoArea_flag[sample(nrow(photos), 10)] <- 'I'
photos$PhotoArea_flag[sample(nrow(photos), 10)] <- 'J'

# Write data to file ----------------------------------------------------------

# message('Writing to file')

write.csv(counts, paste0(path_processed, '/taxa_counts_qcd.csv'), row.names = FALSE)
write.csv(photos, paste0(path_processed, '/taxa_photos_qcd.csv'), row.names = FALSE)

# message('*** DONE ***\n\n')
