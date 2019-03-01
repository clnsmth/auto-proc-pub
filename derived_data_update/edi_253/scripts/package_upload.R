
# Upload data and metadata to the EDI Data Repository

# message('*** UPLOADING DATA PACKAGE TO EDI ***')

# Parameterize ----------------------------------------------------------------


# Upload data and metadata to server ------------------------------------------

con <- suppressMessages(ssh::ssh_connect(
  paste0(server.user.name, '@lter.limnology.wisc.edu'),
  passwd = server.user.pass
))

suppressMessages(ssh::scp_upload(
  session = con,
  files = c('/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/data/taxa_photos_qcd.csv',
            '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/data/taxa_counts_qcd.csv'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_253/data', 
  verbose = F
))

suppressMessages(ssh::scp_upload(
  session = con,
  files = paste0('/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/eml',
                 '/', new_package_id, '.xml'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_253/eml',
  verbose = F
))

suppressMessages(ssh::ssh_disconnect(con))

# Upload to EDI ---------------------------------------------------------------

suppressMessages(EDIutils::pkg_update(
  path = '/Users/csmith/Documents/EDI/r/auto-proc-pub/server/edi_253/eml',
  package.id = new_package_id,
  environment = pasta.environment,
  user.id = pasta.user.name,
  user.pass = pasta.user.pass,
  affiliation = pasta.affiliation
))

# message('*** DONE ***\n')