
# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(EDIutils)

# Parameterize ----------------------------------------------------------------

templates_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\metadata_templates_complete"
data_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\data"
eml_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\eml"
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
#   data.file = 'table_2.csv',
#   lat.col = 'latitude',
#   lon.col = 'longitude',
#   site.col = 'site_names'
# )

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
  temporal.coverage = c('1968-09-01', '2010-12-01'),
  geographic.coordinates = c('-77.859626', '166.702327', '-77.863072', '166.675889'),
  geographic.description = 'Cape Armitage, McMurdo Sound, Antarctica',
  maintenance.description = 'Completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.151.5'
)


