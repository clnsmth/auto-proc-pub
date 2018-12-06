

r <- httr::GET(url = paste0(EDIutils::url_env('staging'), 
                            '.lternet.edu/package/eml/edi/151', 
                            '?filter=newest'))
if (r$status_code != 200){
  stop('Cannot access the EDI repository. Try again later.')
}
