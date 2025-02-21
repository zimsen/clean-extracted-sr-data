###############################################################################
#' @ Function name: duplicate_check_dt.R
#' @ Purpose: Screen for potential duplicates
#' @ Inputs: dt = data table you are screening; byvars = character vector; set of varibles that you expect will define unique  observations, i.e. the variables to group by
#' @ Outputs: A list with three elements: 
#' dt = the data table you started with; error_rows = list of all rows flagged with errors; error_text = list of all error text that was printed
#' @ Date: 2021-12
#' @ Notes: edited to run code demo for ESMARConf2022
###############################################################################

## Load packages
pacman::p_load(data.table, openxlsx)

duplicate_check <- function(dt, byvars){
  # Initialize outputs
  error_rows <- list()
  error_text <- list()
  # For your grouping variable set, determine which rows have multiple rows for one grouping set
  dt[, num_rows := .N, by = byvars]
  if(any(dt$num_rows > 1)){
    error_text[["text"]] <- paste("Your groups are not uniquely defined by the variables you have chosen. Confirm your byvars. Then, check for duplicates in these rows:", paste(which(dt$num_rows > 1), collapse = ", "))
  } else {
    error_text[["text"]] <- "Duplicate screening complete, no duplicates found!"
  }
  print(error_text[["text"]])
  error_rows[["rows"]] <- copy(dt[num_rows > 1])
  dt$num_rows <- NULL
  return(list(data = dt,
              error_rows = error_rows, 
              error_text = error_text))
}

## end
