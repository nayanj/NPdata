nrb_fx <- function(fx_codes = NULL, from = NULL, to = NULL) {

  # data begins only from January 1, 2000; if start date is before '2000-01-01'
  # stop and issue an error with message.

  # if fx_codes are not supplied issue stop error
  if (missing(fx_codes) || missing(from) || missing(to)) {
    stop("You need to enter both currency and dates")
  }

  fx_codes <- toupper(fx_codes)

  currency_list <- c("FX_Date", "INR", "USD", "EUR", "GBP", "CHF", "AUD", "CAD",
                     "SGD", "JPY", "CNH", "SWK", "DAK", "HKD", "SAR",
                     "QAR", "THB", "AED", "MYR", "KPW")

  # check whether fx_codes are valid by looking through currency list
  valid_fx_codes <- fx_codes[fx_codes %in% currency_list]
  invalid_fx_codes <- fx_codes[!fx_codes %in% currency_list]

  length_invalid <- length(invalid_fx_codes)

  # stop if fx_codes are not valid; issue also warning
  if (length(fx_codes) == 1L & (length_invalid == length(fx_codes))) {
    stop("Currency ", fx_codes, " is not valid")
  }

  if ((length(fx_codes) > 1L) & (length_invalid == length(fx_codes))) {
    stop("Currencies ", paste(fx_codes, collapse = ","), " are not valid")
  }
  if ((length(fx_codes) > 1L) & (length_invalid < length(fx_codes)) &
      (length_invalid == 1L)) {
    warning("Currency ", invalid_fx_codes, " is not valid")
  }
  if ((length(fx_codes) > 1L) & (length_invalid < length(fx_codes)) &
      (length_invalid > 1L)) {
    warning("Currencies ", paste(invalid_fx_codes, collapse = ","),
            " are not valid")
  }

  # For the remainder, only valid fx_codes are considered

  fx_codes <- valid_fx_codes

  # check whether the begin date and endd ate if entered are in valid format;
  # if not stop with message

  from_val <- regmatches(
    from, regexpr(
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
  # begindate is not before 2014-07-13; if not stop with
  # message
  to_date <- as.Date(to, format = "%Y-%m-%d")
  from_date <- as.Date(from, format = "%Y-%m-%d")

  data_begin_date <- as.Date("2000-01-01", format = "%Y-%m-%d")

  if (difftime(from_date, data_begin_date) < 0) {
    stop("Data is only available for the date beginning ", data_begin_date)
  }

  # begin and end date cannot be greater than system date; if greater use the
  # current date

  if (difftime(from_date, Sys.Date()) > 0 || difftime(to_date, Sys.Date()) > 0) {
    stop("Date is greater than current date ", Sys.Date(), " ; change the date")
  }


  rm(data_begin_date)

  # check whether the begindate is less or equal to enddate ; if not stop
  # with message

  if (difftime(to_date, from_date) < 0) {

    stop("End date ", to, " must not be less than begin date ", from)
  }
  rm(from_val, to_val)

  # parse the web site for the given index
  YY <- substr(from, 1, 4)
  YY1 <- substr(to, 1, 4)
  MM <- substr(from, 6, 7)
  MM1 <- substr(to, 6, 7)
  DD <- substr(from, 9, 10)
  DD1 <- substr(to, 9, 10)

  url_FX <- paste0("http://www.nrb.org.np/detailexchrate.php?",
                   "YY=", YY, "&MM=", MM, "&DD=", DD, "&YY1=", YY1,
                   "&MM1=", MM1, "&DD1=",
                   DD1)

  tem1 <- xml2::read_html(url_FX)
  tem2 <- rvest::html_table(tem1, fill = TRUE, header = FALSE)

  if (difftime(to_date, from_date) == 0) {
    # if from and to are the same, there is no average row
    tem3 <- tem2[[7]][-c(as.numeric(head(rownames(tem2[[7]]), 2)),
                         as.numeric(tail(rownames(tem2[[7]]), 1))), ]

  } else {
    tem3 <- tem2[[7]][-c(as.numeric(head(rownames(tem2[[7]]), 2)),
                         as.numeric(tail(rownames(tem2[[7]]), 3))), ]
  }
  names(tem3) <- c("FX_Date", "INR BUY", "INR SELL", "USD BUY", "USD SELL",
                   "EUR BUY", "EUR SELL", "GBP BUY", "GBP SELL", "CHF BUY",
                   "CHF SELL", "AUD BUY", "AUD SELL", "CAD BUY", "CAD SELL",
                   "SGD BUY", "SGD SELL", "JPY BUY", "JPY SELL", "CNH BUY",
                   "CNH SELL", "SWK SELL", "DAK SELL", "HKD SELL", "SAR BUY",
                   "SAR SELL", "QAR BUY", "QAR SELL", "THB BUY", "THB SELL",
                   "AED BUY", "AED SELL", "MYR BUY", "MYR SELL", "KPW BUY",
                   "KPW SELL")
  tem4 <- tem3[, c("FX_Date", unique(grep(paste(fx_codes, collapse = "|"),
                                          names(tem3), value = TRUE)))]
  rm(tem1, tem2, tem3)

  names(tem4)[-1] <- sub(" ", "_", names(tem4)[-1])

  tem5 <- reshape(tem4, varying = names(tem4)[-1], direction = "long",
                  v.names = "exchange_rate",
                  timevar = "currency", times = names(tem4)[-1])
  # replace currency var with currency and buy_sell by reshaping and remove
  # also id
  tem6 <- data.frame(
    cbind(
      tem5, data.frame(
        do.call(
          rbind, strsplit(tem5$currency, "_")), stringsAsFactors = FALSE)))

  # remove currency and id columns
  tem6$currency <- NULL
  tem6$id <- NULL
  # rename the tem6 columns
  names(tem6) <- c("fx_date", "fx_rate", "fx_codes", "buy_sell")
  # set the order of columns if final data frame
  FY <- tem6[, c("fx_date", "fx_codes", "buy_sell", "fx_rate")]
  # convert exchange rate into mnumeric
  FY$fx_rate <- as.numeric(FY$fx_rate)

  # convert date to date format
  FY$fx_date <- as.Date(FY$fx_date, format = "%Y-%m-%d")
  # change the rowname from 1 to nrow(FY)
  rownames(FY) <- 1:nrow(FY)
  # convert currency and buy_sell columns elements into lower case
  FY[, 2:3] <- lapply(FY[, 2:3], tolower)


  rm(tem4, tem5, tem6)
  FY



}
