
# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(EDIutils)

# Parameterize ----------------------------------------------------------------

templates_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\metadata_templates_incomplete"
data_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\data"
eml_path <- "C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\create_metadata\\eml"
file_names <- c("table_1.csv", "table_2.csv")

# Import EMLassemblyline template files ---------------------------------------

import_templates(
  path = templates_path,
  data.path = data_path,
  license = 'CC0',
  data.files = file_names
)

# Define categorical variables ------------------------------------------------

define_catvars(
  path = templates_path, 
  data.path = data_path
)

# Define geographic coverage --------------------------------------------------

extract_geocoverage(
  path = templates_path,
  data.file = 'table_2.csv',
  lat.col = 'latitude',
  lon.col = 'longitude',
  site.col = 'site_names'
)