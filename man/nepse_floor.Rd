\name{nepse_floor}
\alias{nepse_floor}
\title{Nepal  Stock Exchange Floor Sheet}
\description{
\code{nepse_floor} downloads floor sheet from Nepal Stock Exchange.
}
\usage{
nepse_floor(symbol = NULL,from = NULL,to = NULL)
}
\arguments{
       \item{symbol}{ a character string naming the symbol of stock
                        to be loaded}
        \item{from}{ begin date expressed in ISO CCYY-MM-DD format
                         (e.g.,"2015-07-08"). The \code{from} must not
                     be less than "2014-07-13"}
        \item{to}{ end date expressed in ISO CCYY-MM-DD format
                      (e.g., "2015-07-09"). The \code{to} must not be
                     less than \code{from}}
%       \item{warnings}{ boolean to turn on warnings. (TRUE)}
}
\details{
The \code{nepse_floor} downloads floor sheet for a given stock symbol and
given begin and end dates from Nepal Stock Exchange . The \code{nepse_floor}
will first check whether the entered symbol is the valid stock symbol by
looking through all stocks symbols listed in NEPSE. The error with message are
issued for an invalid stock symbol but valid dates. For a valid stock symbol
and an invalid begin date or end date, the \code{nepse_floor} will return an
error along with message. For a valid stock symbol and valid begin date and
end date, the end date must be greater than or equal to the begin date, else
the \code{nepse_floor} will return an error along with message. If the begin
date is in valid format, it must not be less than "2014-07-13".
}
\value{
\code{nepse_floor} will return the object of class dataframe with 8 variables:
\code{floor_date},
\code{stock_symbol},
\code{contract_no},
\code{buyer_broker},
\code{seller_broker},
\code{quantity},
\code{rate}, and
\code{amount}.

}
\references{
\url{http://www.nepalstock.com.np/}
}

\author{ Nayan Krishna Joshi}

\examples{
\dontrun{
# floor sheet for an invalid stock symbol and valid begin date and end date;
# issues an error with message nepse_floor('JOSHI','2015-07-08','2015-07-09')

# floor sheet for a valid stock symbol and an invalid begin date or end date;
# issues an error with message nepse_floor('HBL','2015-07','2015-07-09')
# nepse_floor('HBL','2015-07-09','2015-07')
# nepse_floor('HBL','2015-07','2015-07')

# floor sheet for a valid stock symbol and valid begin date and end date but
# begin date is greater than end date; issues an error with message
# nepse_floor('HBL','2015-07-09','2015-07-08')

# floor sheet for a valid stock symbol and valid begin date and end date and
# begin date is less than or equal to end date; returns a dataframe with non-NA
# values
nepse_floor("HBL", "2015-07-08", "2015-07-08")
nepse_floor("HBL", "2015-07-08", "2015-07-09")

# compute average stock price, total number of transactions, total quantity of
# shares, and total amount of shares conducted by buyer broker 36 during
# March-June 2015 for 'HBL' stock
require(data.table)
dt_hbl <- as.data.table(nepse_floor("HBL", "2015-03-01", "2015-06-30"))
dt_hbl[
  buyer_broker == 36, .(avg_rate = mean(rate), transaction_no = .N,
                        quantity = sum(quantity), amount = sum(amount))]
}
}
