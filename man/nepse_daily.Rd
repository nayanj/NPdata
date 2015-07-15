\name{nepse_daily}
\alias{nepse_daily}
\title{Nepal Stock Exchange Daily Stock Quote}
\description{
\code{nepse_daily} downloads the daily stock quote from the Nepal Stock Exchange.
}
\usage{
nepse_daily(symbol = NULL,date = NULL)
}
\arguments{
       \item{symbol}{ a character string naming the symbol of stock to be
                     loaded}
        \item{date}{ date expressed in ISO CCYY-MM-DD format (e.g., "2015-07-08").
                  The data is not available for the date prior to "2010-05-09".}
}
\details{
The \code{nepse_daily} downloads the daily stock quote for a given stock symbol
and given date from Nepal Stock Exchange. The \code{nepse_daily} will first
check whether the entered symbol is the valid stock symbol by looking through
all stocks symbols listed in NEPSE. The \code{nepse_daily} will issue an error
with message if symbol is invalid but date is in valid format. It will also
issue an error with message if symbol is valid but date is not in valid format.
If the date is in valid format, it must not be less than "2010-05-09".}

\value{
\code{nepse_daily} will return the object of class dataframe with 10 variables:
\code{daily_date},
\code{stock_symbol},
\code{transaction_no},
\code{max_price},
\code{min_price},
\code{closing_price},
\code{traded_shares},
\code{amount},
\code{previous_closing}, and
\code{difference}
}

\references{
\url{http://www.nepalstock.com.np/}
}

\author{ Nayan Krishna Joshi}

\examples{
\dontrun{

# daily stock quote for an invalid stock symbol JOSHI and valid date; returns an
# error with message nepse_daily('JOSHI','2015-07-08')

# daily stock quote for a valid stock symbol HBL and an invalid date; returns an
# error with message nepse_daily('HBL','2015-07')

# daily stock quote for an invalid stock symbol JOSHI and an invalid date;
# returns an error with message nepse_daily('JOSHI','2015-07')

# daily stock quote for a valid stock symbol HBL and a valid date; returns a
# dataframe with non-NA values
nepse_daily("HBL", "2015-07-08")

# daily stock quote for a valid stock symbol HBL and valid dates; returns a
# dataframe with non-NA values
dates_list <- c("2015-07-08", "2015-07-09")
data_daily1 <- do.call(rbind, lapply(dates_list, function(dates) {
  nepse_daily("HBL", dates)
}))

# daily stock quote for valid stock symbols HBL and ADBL and a valid date;
# returns a dataframe with non-NA values
stocks_list <- c("HBL", "ADBL")
data_daily2 <- do.call(rbind, lapply(stocks_list, function(stocks) {
  nepse_daily(stocks, "2015-07-08")
}))

# daily stock quote for valid stock symbols HBL for '2015-07-08' and ADBL for
# '2015-07-09' ; returns a dataframe with non-NA values stocks_list and
# dates_list same as above
data_daily3 <- do.call(rbind, Map(function(stocks, dates) {
  nepse_daily(stocks, dates)
}, stocks_list, dates_list))

# draw an interactive time series chart of closing price for a stock symbol HBL
# for March, 2015
dates_march2015 <- as.character(
  seq.Date(from = as.Date("2015-03-01"), to = as.Date("2015-03-31"),
                                         by = 1))
data_daily4 <- do.call(rbind, lapply(dates_march2015, function(dates) {
  nepse_daily("HBL", dates)
}))
data_daily5 <- data_daily4[
  complete.cases(data_daily4), c("daily_date", "closing_price")]
# NA for non-traded days
require(xts)
require(dygraphs)
data_daily5 <- xts(data_daily5[, -1], order.by = data_daily5[, 1])
graph_daily <- dygraph(data_daily5[, 1],
                       main = "Time series graph of HBL for Month of March, 2015")
dyRangeSelector(graph_daily, height = 20, strokeColor = "darkred")


# compute daily, weekly, monthly, quartely, and yearly returns of closing price
# for a stock symbol HBL for March, 2015
require(xts)
require(quantmod)
# data_daily5 : xts object same as above arithmetic returns
return_daily_re_arithm <- allReturns(data_daily5)
# logarithmic returns
return_daily_re_log <- allReturns(data_daily5, type = "log")
}
}
