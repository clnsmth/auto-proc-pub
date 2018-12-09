
# Create EML for time series update

message('*** CREATING EML METADATA ***')

# Parameterize ----------------------------------------------------------------

path_templates <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/metadata_templates'
path_data <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/data'
path_eml <- '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/eml'
file_names <- c("taxa_counts_qcd.csv", "taxa_photos_qcd.csv")
pkg_identifier <- 'edi.253'
environment <- 'staging'
usr_pasta <- 'csmith'
affiliation <- 'LTER'

# Get new temporal coverage ---------------------------------------------------

x <- read.csv(paste0(path_data, '/taxa_photos_qcd.csv'))
temporal_coverage <- c(
  paste0(as.character(min(x$Year)), '-01-01'),
  paste0(as.character(max(x$Year)), '-01-01')
)

# Get new package revision number ---------------------------------------------

pkg_id <- stringr::str_replace_all(pkg_identifier, '\\.', '/')
r <- httr::GET(url = paste0(EDIutils::url_env(environment), 
                            '.lternet.edu/package/eml/', 
                            pkg_id, '?filter=newest'))
revision <- httr::content(r, encoding = 'UTF-8')
revision <- as.character(as.numeric(revision) + 1)
package_id <- paste0(pkg_identifier, '.', revision)

# Get newest provenance package revision number -------------------------------

sir <- stringr::str_replace_all(sir, '/', '\\.')

# Make EML --------------------------------------------------------------------

make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml,
  dataset.title = 'McMurdo Sound, Antarctica: Cape Armitage, sponge abundance and cover and photo ID information: Quality controlled',
  data.files = file_names,
  data.files.description = c('Benthic invertebrate photo metadata of McMurdo Sound, Antarctica',
                             'Benthic invertebrates of McMurdo Sound, Antarctica'),
  data.files.url = 'https://lter.limnology.wisc.edu/sites/default/files/data/edi/tests/edi_253/data',
  temporal.coverage = temporal_coverage,
  geographic.coordinates = c('-77.859626', '166.702327', '-77.863072', '166.675889'),
  geographic.description = 'Cape Armitage, McMurdo Sound, Antarctica',
  maintenance.description = 'Ongoing',
  user.id = usr_pasta,
  affiliation = affiliation,
  package.id = package_id,
  environment = 'staging',
  provenance = sir
)

message('*** DONE ***\n\n')
