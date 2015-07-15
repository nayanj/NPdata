nepse_daily <- function(symbol = NULL, date = NULL) {
  # date starts from 2010-05-07

  # only one symbol and one date at one call

  # if symbols are not supplied issue stop error
  if (missing(symbol) || missing(date)) {
    stop("You need to enter both the symbol and date")
  }

  # convert the non-missing symbol to upper case
  symbol <- toupper(symbol)

  if (!symbol %in% NPdata::nepse_stock_symbols$stock_symbol) {

    stop("Symbol ", symbol, " is not valid")
  }

  # check whether the date is in valid format; stop with a message if an invalid
  dateval <- regmatches(date, regexpr(
     "^(19|20)\\d\\d[- //.](0[1-9]|1[012])[- //.](0[1-9]|[12][0-9]|3[01])$",
                                      date))
  # http://www.regular-expressions.info/dates.html
  if (length(dateval) == 0) {

    stop("Date ", date, " is not in valid date format ", "YYYY-MM-DD")
  }

  # check whether the valid date is before 2010-05-07; if yes stop with message
  date_begin_date <- as.Date("2010-05-07", format = "%Y-%m-%d")

  if (difftime(as.Date(date, format = "%Y-%m-%d"), date_begin_date) < 0) {
    stop("Data is available only for the date beginning ", date_begin_date)
  }

  # remove the dateval, date_begin_date
  rm(dateval, date_begin_date)

   # parse the website and check whether the data is available for the given
   # date and given symbol
  tem1 <- httr::POST(url = "http://www.nepalstock.com.np/todaysprice",
                     body = list(`stock-symbol` = symbol, startDate = date))
  tem2 <- xml2::read_html(tem1)
  tem3 <- rvest::html_nodes(tem2, "td")

  # if there is no data for the given date and given symbol, return dataframe
  # with NA
  if (rvest::html_text(tem3[12]) == "No Data Available!") {
    daily <- data.frame(t(rep(NA, 7)), stringsAsFactors = FALSE)
  } else {
    # if there is data for the given date and given symbol, return dataframe
    # daily <- data.frame(
    # t(sub("Â", "", rvest::html_text(tem3[14:21], trim = TRUE))),
    #                         stringsAsFactors = FALSE)
    # Â is non-ascii character so can't use in package

     daily <- data.frame(t(rvest::html_text(tem3[14:20], trim = TRUE)),
                                              stringsAsFactors = FALSE)
  }
  # remove intermediate objects
  rm(tem1, tem2, tem3)

  # convert characters into numeric
  daily[, 1:7] <- lapply(daily, as.numeric)

  # name the columns of data frame
  names(daily) <- c("transaction_no", "max_price", "min_price", "closing_price",
                    "traded_shares", "amount", "previous_closing")

  # becaause of non-ascii characters associated with difference column,
  # I didn't use that from the website
  daily$difference <- daily$previous_closing - daily$closing_price

  # create a data_date column with nepal standard time
  daily$daily_date <- as.POSIXct(date, format = "%Y-%m-%d",
                                 tz = "Asia/Kathmandu", usetz = TRUE)
  # stock_symbol
  daily$stock_symbol <- symbol
  daily <- daily[, c("daily_date", "stock_symbol", "transaction_no",
                     "max_price", "min_price", "closing_price", "traded_shares",
                     "amount", "previous_closing", "difference")]

  daily
}
