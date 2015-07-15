nepse_real <- function(symbols = NULL) {
  # all are lower cases

  # if symbols are not supplied issue stop error
  if (missing(symbols)) {
    stop("You need to enter at least one symbol. Please check
         http://www.nepalstock.com.np/company for further details.")
  }
  symbols <- toupper(symbols)

  # check whether symbols are valid by looking through nepse_stock_symbols
  valid_symbols <- symbols[
    symbols %in% NPdata::nepse_stock_symbols$stock_symbol]

  invalid_symbols <- symbols[
    !symbols %in% NPdata::nepse_stock_symbols$stock_symbol]

  length_invalid <- length(invalid_symbols)

  # stop if symbols are not valid; issue also warning
  if (length(symbols) == 1L & (length_invalid == length(symbols))) {
    stop("Symbol ", symbols, " is not valid")
  }

  if ((length(symbols) > 1L) & (length_invalid == length(symbols))) {
    stop("Symbols ", paste(symbols, collapse = ","), " are not valid")
  }
  if ((length(symbols) > 1L) & (length_invalid < length(symbols))
      & (length_invalid == 1L)) {
    warning("Symbol ", invalid_symbols, " is not valid")
  }
  if ((length(symbols) > 1L) & (length_invalid < length(symbols))
      & (length_invalid > 1L)) {
    warning("Symbols ",
            paste(invalid_symbols, collapse = ","), " are not valid")
  }

  #For the remainder, only valid symbols are considered
  symbols <- valid_symbols

  #trading hour warning
  posix_trading <- as.POSIXlt(Sys.time(), tz = "Asia/Kathmandu", usetz = TRUE)
  if (!
      (
        (posix_trading$wday %in% 1:4) & (posix_trading$hour %in% 12:15))
      ) {
    warning("
To get the real-time stock quote, you should call this function only during
NEPSE trading day and hours.")
}
  # parse the website
  real_parse <- xml2::read_html(
    curl::curl("http://www.nepalstock.com.np/stocklive",
                            handle = new_handle("useragent" = "my_user_agent")))
  real_tables<- rvest::html_table(
    real_parse, header = TRUE, fill = TRUE, trim = TRUE)

  # tables_parse <- XML::readHTMLTable("
  # http://www.nepalstock.com.np/stocklive",header = FALSE)
  # the first list is the data
  tem1 <- real_tables[[1]]

  # convert to characters because there are commas and minus
  #tem1[] <- lapply(tem1, as.character)

  # the [1,1] of second list is the date
  quote_date <- sub("As of", "", as.character(real_tables[[2]][1, 1]))

  # convert date format to nepal standard time
  quote_posix <- as.POSIXct(quote_date, format = "%Y-%m-%d %H:%M:%S",
                            tz = "Asia/Kathmandu", usetz = TRUE)
  # don't need tables_parse
  rm(real_parse, real_tables, length_invalid)

  # get the unique list of all traded symbols
  symbols_traded_df <- unique(tem1[, 2])

  # now, you need to see whether the entered symbols are in the
  # nepse_stock_symbols. Create two seperate symbols a)length of symbols in the
  # transaction list
  length_symbols_transac <- length(which(symbols %in% symbols_traded_df))

  # b)length of symbols not in the transaction list
  length_symbols_nottransac <- length(which(!symbols %in% symbols_traded_df))

  # if the length of entered symbols which do match symbols_traded_df is 0 but
  # which do not match symbols_traded_df not 0, then output with the dataframe
  # of NA's whose row is equal to the number of symbols that donot match
  # symbols_traded_df and which column numbers is always 9 plus quote posix date
  # time

  if (length_symbols_transac == 0L & length_symbols_nottransac > 0L) {
    if (length_symbols_nottransac == 1L) {
      warning("Symbol ", symbols, " is valid but not currently traded")
    } else {
      warning("Symbols ", paste(symbols, collapse = ","), " are valid
              but not currently traded ")
    }

    tem2 <- data.frame(quote_posix, symbols,
               matrix(data = NA, nrow = length_symbols_nottransac, ncol = 9))
  }

  # if the length of entered symbols which do match symbols_traded_df is > 0 but
  # which do not match symbols_traded_df is 0, then output with the dataframe of
  # quotes whose row is equal to the number of symbols that match
  # symbols_traded_df and which column numbers is always 9 plus quote posix date
  # time


  if (length_symbols_transac > 0L & length_symbols_nottransac == 0L) {

    # generate the column of symbols
     stock_symbol<-symbols_traded_df[symbols_traded_df %in% symbols]

    tem2 <- data.frame(
      quote_posix, stock_symbol,
      tem1[
        symbols_traded_df %in% symbols, 3:ncol(tem1)],stringsAsFactors = FALSE)
    # remove all commas and convert it to numeric

    tem2[, 3:ncol(tem2)] <- lapply(
      tem2[, 3:ncol(tem2)], function(col)as.numeric(gsub(",", "", col)))
  }

  # if the length of entered symbols which do match symbols_traded_df is > 0
  # but which do not match symbols_traded_df is > 0, then output with the
  # dataframe of quotes whose cbinds two dataframe: a) tem201: dataframe of NA's
  # whose row is equal to the number of symbols that donot match
  # symbols_traded_df and which column numbers is always 9 plus quote posix date
  # time b) tem202: which row is equal to the number of symbols that match
  # symbols_traded_df and which column numbers is always 9 plus quote posix date
  # time also issue warnings that some symbols are not valid

  if (length_symbols_transac > 0L & length_symbols_nottransac > 0L) {

    # generate the column of non-traded symbols
    non_traded<-symbols[which(!symbols %in% symbols_traded_df)]

    #create a dataframe of NA's for non-traded symbols
    tem201 <- data.frame(quote_posix, non_traded,
                  matrix(data = NA_real_, nrow = length_symbols_nottransac,
                         ncol = 9), stringsAsFactors = FALSE)
    # generate the column of traded symbols
    stock_symbol<-symbols_traded_df[symbols_traded_df %in% symbols]

    #create a dataframe of traded symbols
    tem202 <- data.frame(quote_posix, stock_symbol,
                  tem1[symbols_traded_df %in% symbols, 3:ncol(tem1)],
                  stringsAsFactors = FALSE)

    # remove all commas and convert it to numeric
    tem202[, 3:ncol(tem202)] <- lapply(
      tem202[, 3:ncol(tem202)], function(col) as.numeric(gsub(",", "", col)))


    # for rbinding
    names(tem201)<-names(tem202)

    #rbind tem201 and tem202
    tem2 <- data.frame(rbind(tem201, tem202))

    # issue warning for valid but not traded symbols
    if (length_symbols_nottransac == 1L) {
      warning("Symbol ", non_traded,
              " is valid but not currently traded ")
    } else {
      warning("Symbols ", paste(non_traded, collapse = ","),
        " are valid but not currently traded ")
    }

    #remove all intermediate objects
    rm(tem201, tem202, non_traded, stock_symbol)
  }


  # rename the columnnames
  colnames(tem2) <- c("trade_time", "stock_symbol", "last_trade_price",
                      "last_trade_volume", "point_change", "percent_change",
                      "open", "high", "low", "volume", "previous_closing")


  # assign the tem2 to real
  real <- tem2

  # set the new rownames

  rownames(real)<-1:nrow(real)

  #remove all intermediate objects
  rm(tem1,tem2)

  #final dataframe
  real
}
