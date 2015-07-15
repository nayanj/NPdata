nepse_floor <- function(symbol = NULL, from = NULL, to = NULL) {
  # begin date starts from '2014-07-13' scientific notation off : contract
  # number
  options(scipen = 999)
  # only one symbol and one date at one call

  # tmp <- tempfile() on.exit(unlink(tmp)) show(symbols) all uppercase if
  # some or all are lower cases

  # if symbols are not supplied issue stop error
  if (missing(symbol) || missing(from) || missing(to)) {
    stop("You need to enter both the symbol and dates")
  }

  # convert the non-missing symbol to upper case
  symbol <- toupper(symbol)

  if (!symbol %in% NPdata::nepse_stock_symbols$stock_symbol) {

    stop("Symbol ", symbol, " is not valid")
  }
  # check whether the from and to are in valid format; if not
  # stop with message
  from_val <- regmatches(
    from,
    regexpr(
      "^(19|20)\\d\\d[- //.](0[1-9]|1[012])[- //.](0[1-9]|[12][0-9]|3[01])$",
      from))
  to_val <- regmatches(
    to, regexpr(
      "^(19|20)\\d\\d[- //.](0[1-9]|1[012])[- //.](0[1-9]|[12][0-9]|3[01])$",
      to))

  # http://www.regular-expressions.info/dates.html
  if (length(from_val) == 0) {

    stop("Begin date ", from, " is in invalid date format ", "YYYY-MM-DD")
  }
  if (length(to_val) == 0) {

    stop("End date ", to, " is in invalid date format ", "YYYY-MM-DD")
  }

  # Data for begin date only available from '2014-07-13' check whether the
  # from is not before 2014-07-13; if not stop with message

  date_begin_date <- as.Date("2014-07-13", format = "%Y-%m-%d")

  if (difftime(as.Date(from, format = "%Y-%m-%d"), date_begin_date) < 0) {
    stop("Data is only available for the date beginning ", date_begin_date)
  }
  rm(date_begin_date)

  # check whether the from is less or equal to to ; if not stop
  # with message

  if (difftime(
    as.Date(to, format = "%Y-%m-%d"), as.Date(from, format = "%Y-%m-%d")) < 0) {

    stop("End date ", to, " shouldnot be less than begin date ", from)
  }
  rm(from_val, to_val)

  # cases with to is greater than or equal to  from date

     # parse the website and check whether the data is available for the given
  # date and given symbol

  # http://www.nepalstock.com.np/company/transactions/ACEDBL
  tem1 <- httr::POST(url =
          paste0("http://www.nepalstock.com.np/company/transactions/", symbol),
          body = list(startDate = from, endDate = to, `_limit` = 500))
  tem2 <- xml2::read_html(tem1)
  tem3 <- rvest::html_nodes(tem2, "td")

  # if there is no data for the given date and given symbol, return dataframe
  # with NA
  if (rvest::html_text(tem3[10]) == "No Data Available!") {
    floor <- data.frame(t(rep(NA, 6)), stringsAsFactors = FALSE)
    floor[, 1:6] <- lapply(floor, as.numeric)
    rm(tem1, tem2, tem3)
  } else {
    # count the maximum page to download
    max_page <- as.numeric(sub("\\/", "", regmatches(
      rvest::html_text(tail(tem3, 1)),
      regexpr("\\/\\d+", rvest::html_text(tail(tem3, 1))))))

    if (max_page == 1) {
      # just download this

      # if there is data for the given date and given symbol, return dataframe
      # warnings issued when converted from matrix to dataframe: doesn't require
      # so suppress here and in all cases where matrix converted to data.frame
      floor01 <- suppressWarnings(
        data.frame(
        matrix(
        rvest::html_text(
          tem3[2:length(tem3)]),
        ncol = 8, byrow = TRUE),
        stringsAsFactors = FALSE))

      floor02 <- floor01[-c(1, nrow(floor01)), -c(1, 3)]
      floor02[, 2:3] <- lapply(floor02[, 2:3], as.integer)
      floor02[, c(1, 4:6)] <- lapply(floor02[, c(1, 4:6)], as.numeric)
      floor <- floor02
      rm(floor01, floor02)
      rm(tem1, tem2, tem3, max_page)
    } else {
      # Doesn't allow me to select multiple pages each with 500,even with page
      # 50 so has to repeat with 20 pages: will be too slow; so parse the first
      # page by incremental date until the end date
      max_time <- as.numeric(
        difftime(
          as.Date(to, format = "%Y-%m-%d"),
          as.Date(from, format = "%Y-%m-%d")))

      # repeat by sequence of 5 days define last element of sequence
      # I think it needs by 5 days since when you check ADBL data from
      # 2014-08-06 to 2014-08-06, it has already 490 transactions. So, do by
      # 5 days
      last_elem_seq <- tail(seq(0, max_time, 5), 1)
      # define sequence num
      seq_num <- if (max_time > last_elem_seq) {
        c(seq(0, max_time, 5), max_time)
      } else {
        seq(0, max_time, 5)
      }

      # define the beginning and ending sequence
      seq_begin <- seq_num[-length(seq_num)]
      seq_begin <- c(0, seq_begin[-1] + 1)
      # Add 1 to all except first which is still 0

      # end sequence
      seq_end <- seq_num[-1]
      # loop over begin sequence and end seq
      floor <- suppressWarnings(
        data.frame(
          do.call(
            rbind,
            Map(
              function(begin, end) {
        begin_date <- as.character(
          as.Date(from, format = "%Y-%m-%d") + begin)
        end_date <- as.character(
          as.Date(from, format = "%Y-%m-%d") + end)
        tem1 <- httr::POST(
          url = paste0("http://www.nepalstock.com.np/company/transactions/",
                       symbol), body = list(startDate = begin_date,
                                            endDate = end_date, `_limit` = 500))
        message("computing in steps for ", paste(
          begin_date, end_date, sep = " & "))

        rm(begin_date, end_date)
        tem2 <- xml2::read_html(tem1)
        tem3 <- rvest::html_nodes(tem2, "td")
        floor01 <- data.frame(
          matrix(
            rvest::html_text(tem3[2:length(tem3)]),
            ncol = 8, byrow = TRUE),
          stringsAsFactors = FALSE)

        floor02 <- floor01[-c(1, nrow(floor01)), -c(1, 3)]
        floor02[, 2:3] <- lapply(floor02[, 2:3], as.integer)
        floor02[, c(1, 4:6)] <- lapply(floor02[, c(1, 4:6)], as.numeric)
        rm(floor01, tem1, tem2, tem3)
        return(floor02)
      },
      seq_begin, seq_end))))
    }
  }
# }
  # name the columns of data frame
  names(floor) <- c("contract_no", "buyer_broker", "seller_broker", "quantity",
                    "rate", "amount")
  #create a data_date column with nepal standard time

  rownames(floor) <- 1:nrow(floor)
  floor$stock_symbol <- rep(symbol, nrow(floor))
  floor$floor_date <- as.POSIXct(
    substr(floor$contract_no, 1, 8),
    format = "%Y%m%d", tz = "Asia/Kathmandu", usetz = TRUE)
  floor <- floor[, c("floor_date", "stock_symbol",  "contract_no",
                     "buyer_broker", "seller_broker", "quantity", "rate",
                     "amount")]

  floor
}
