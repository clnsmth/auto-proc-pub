
# Parameterize ----------------------------------------------------------------

templates_path <- paste0(path_local, '/tests/edi_151/metadata_templates')
data_path <- paste0(path_local, '/tests/edi_151/data')
eml_path <- paste0(path_local, '/tests/edi_151/eml')
file_names <- c("table_1.csv", "table_2.csv")

# Import EMLassemblyline template files ---------------------------------------

# import_templates(
#   path = templates_path,
#   data.path = data_path,
#   license = 'CC0',
#   data.files = file_names
# )

# Define categorical variables ------------------------------------------------

# define_catvars(
#   path = templates_path, 
#   data.path = data_path
# )

# Define geographic coverage --------------------------------------------------

# extract_geocoverage(
#   path = templates_path,
#   data.file = 'CA_SpeciesData.csv',
#   lat.col = 'latitude',
#   lon.col = 'longitude',
#   site.col = 'site_names'
# )

# Get new package revision number ---------------------------------------------

pkg_id <- stringr::str_replace_all(package.identifier, '\\.', '/')

r <- httr::GET(
  url = paste0(EDIutils::url_env(environment), '.lternet.edu/package/eml/', 
               pkg_id, '?filter=newest'),
  config = httr::authenticate(auth_key(usr_pasta, affiliation), pass_pasta)
)

package_id <- paste0(package.identifier, '.', content(r))

# Get new temporal coverage ---------------------------------------------------

x <- read.csv(paste0(data_path, '/table_1.csv'))
temporal_coverage <- c(
  paste0(as.character(min(x$Year)), '-01-01'),
  paste0(as.character(max(x$Year)), '-01-01')
)

# Make EML --------------------------------------------------------------------

make_eml(
  path = templates_path,
  data.path = data_path,
  eml.path = eml_path,
  dataset.title = 'McMurdo Sound, Antarctica: Cape Armitage, sponge abundance and cover and photo ID information for 1968 and 2010',
  data.files = file_names,
  data.files.description = c('Benthic invertebrate photo metadata of McMurdo Sound, Antarctica',
                             'Benthic invertebrates of McMurdo Sound, Antarctica'),
  data.files.url = 'https://lter.limnology.wisc.edu/sites/default/files/data/edi',
  temporal.coverage = temporal_coverage,
  geographic.coordinates = c('-77.859626', '166.702327', '-77.863072', '166.675889'),
  geographic.description = 'Cape Armitage, McMurdo Sound, Antarctica',
  maintenance.description = 'Ongoing',
  user.id = usr_pasta,
  affiliation = affiliation,
  package.id = package_id
)

