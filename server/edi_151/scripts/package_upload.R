
# Upload data and metadata to the EDI Data Repository

message('*** UPLOADING DATA PACKAGE TO EDI ***')

# Parameterize ----------------------------------------------------------------

serv_name <- '@lter.limnology.wisc.edu' # Name of the server to which 'usr_serv' will be prepended (e.g. @lter.limnology.wisc.edu)

# Below are a series of paths that you'll need to configure for your workflow. See
# function documentation for argument definitions.

# Upload data and metadata to server ------------------------------------------

# Connect to server
con <- ssh::ssh_connect(
  paste0(usr_serv, serv_name),
  passwd = pass_serv
)

# Upload data tables
ssh::scp_upload(
  session = con,
  files = c('/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/data/processed/taxa_photos.csv',
            '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/data/processed/taxa_counts.csv'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_151/data/processed', 
  verbose = F
)

# Upload EML file
ssh::scp_upload(
  session = con,
  files = paste0('/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/eml',
                 '/', package_id, '.xml'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_151/eml',
  verbose = F
)

# Disconnect
ssh::ssh_disconnect(con)

# Upload to EDI ---------------------------------------------------------------

EDIutils::pkg_update(
  path = '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_151/eml',
  package.id = package_id,
  environment = environment,
  user.id = usr_pasta,
  user.pass = pass_pasta,
  affiliation = affiliation
)

message('*** DONE ***\n')