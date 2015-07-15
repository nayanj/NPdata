nepse_index <- function(index = NULL) {

  # data begins from Janurary 8, 2015; if index is not supplied issue stop error

  if (missing(index)) {
    stop("You need to enter an index id")
  }

  # create a dataframe of index_id and index_name

  if (!index %in% NPdata::nepse_index_id$index_id) {
    stop("You need to enter valid index id")
  }

  # parse the web site for the given index
  url_index <- "http://www.nepalstock.com.np/indices"
  tem1 <- httr::POST(url = url_index, body = list(index = index))
  tem2 <- xml2::read_html(tem1)
  tem3 <- rvest::html_table(tem2, fill = TRUE)
  tem4 <- tem3[[1]][2:5][-c(1, 2), ]
  names(tem4) <- c("index_date", "index_value",
                   "absolute_change", "percent_change")

  # convert to the date format
  tem4$index_date <- as.Date(tem4$index_date, format = "%Y-%m-%d")

  # create a variable index name and assign it the index_name using
  # nepse_index_id data
  index_name <- as.character(
    NPdata::nepse_index_id[
      NPdata::nepse_index_id[["index_id"]] == index, "index_name"])

  # remove % symbol in percent_change
  tem4$percent_change <- sub("%", "", tem4$percent_change)

  # convert columns 2 to 4 to numeric
  tem4[, 2:4] <- lapply(tem4[, 2:4], as.numeric)

  # assign the rownames from 1 to nrow (tem4)
  rownames(tem4) <- 1:nrow(tem4)

  #to make compatibility with quantmod for computing returns
  tem4$index_name <- index_name

  # assign tem4 to nepse_index and return first two columns: date and
  # index value
  nepse_index <- tem4[, c("index_date", "index_name", "index_value")]

  # remove all intermediate objects
  rm(tem1, tem2, tem3, tem4, index_name, url_index)

  # return nepse_index
  nepse_index

}
