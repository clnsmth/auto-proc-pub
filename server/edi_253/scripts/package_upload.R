
# Upload data and metadata to the EDI Data Repository

message('*** UPLOADING DATA PACKAGE TO EDI ***')

# Parameterize ----------------------------------------------------------------

environment <- 'staging'
affiliation <- 'LTER'

# Upload data and metadata to server ------------------------------------------

con <- ssh::ssh_connect(
  paste0(usr_serv, '@lter.limnology.wisc.edu'),
  passwd = pass_serv
)

ssh::scp_upload(
  session = con,
  files = c('C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\data\\taxa_photos_qcd.csv',
            'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\data\\taxa_counts_qcd.csv'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_253/data', 
  verbose = F
)

ssh::scp_upload(
  session = con,
  files = paste0('C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\eml',
                 '/', package_id, '.xml'),
  to = '/var/www/lter/sites/default/files/data/edi/tests/edi_253/eml',
  verbose = F
)

ssh::ssh_disconnect(con)

# Upload to EDI ---------------------------------------------------------------

EDIutils::pkg_update(
  path = 'C:\\Users\\Colin\\Documents\\EDI\\r\\auto-proc-pub\\server\\edi_253\\eml',
  package.id = package_id,
  environment = environment,
  user.id = usr_pasta,
  user.pass = pass_pasta,
  affiliation = affiliation
)

message('*** DONE ***\n')