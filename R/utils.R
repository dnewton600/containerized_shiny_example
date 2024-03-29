validate_data = function(data) {
  
  is_valid = TRUE
  err_msg = ''
  
  if(is.null(data)) {
    
    err_msg = "Error: Data is null"
    is_valid = FALSE
    
  } else if(any(names(data)!=c('y','groups'))) {
    
    err_msg = "Error: Invalid data columns"
    is_valid = FALSE
  
  } else if(any(c(is.na(data$y),is.na(data$groups)))) {
    
    err_msg = "Error: NAs detected in data rows."
    is_valid = FALSE
    
  }
  
  return(list(is_valid = is_valid,err_msg = err_msg))
  
  
}