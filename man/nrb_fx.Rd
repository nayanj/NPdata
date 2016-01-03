\name{nrb_fx}
\alias{nrb_fx}
\title{
Buying and Selling Foreign Exchange Rates from Nepal Rastra Bank
}
\description{
\code{nrb_fx} downloads foreign exchange rates from Nepal Rastra Bank.
}

\usage{
nrb_fx(fx_codes = NULL, from = NULL, to = NULL, showProgress = TRUE)
}
\arguments{
       \item{fx_codes}{ a character vector of currency symbols expressed in
                         ISO 4217 currency code format.}
        \item{from}{ begin date expressed in ISO CCYY-MM-DD format
                         (e.g.,"2015-07-08"). The \code{from} must not
                     be less than "2000-01-01"}
        \item{to}{ end date expressed in ISO CCYY-MM-DD format
                      (e.g., "2015-07-09"). The \code{to} must not be
                     less than the \code{from}}
       \item{showProgress}{default is TRUE. Displays progress on the console}
}
\details{
The \code{nrb_fx} downloads buying and selling exchange rates for a
given currency symbols and the given begin and end dates from Nepal Rastra Bank.
The \code{nrb_fx} will return an error with message if currency symbols are not
valid. For a valid currency symbol and valid begin date and end date, the end
date must be greater than or equal to the begin date, else the \code{nrb_fx}
will return an error along with message. If the begin date is in valid format,
it must not be less than "2000-01-01".}
\value{
\code{nrb_fx} will return the object of class dataframe with 4 variables:
\code{fx_date},
\code{fx_codes},
\code{buy_sell}, and
\code{fx_rate}
}
\references{
\url{https://en.wikipedia.org/wiki/ISO_4217} for currency codes
}
\author{
Nayan Krishna Joshi
}
\note{
Buying and Selling rates exist only for selected currency symbols. See
\url{http://www.nrb.org.np/fxmexchangerate.php} for details. For Japanese Yen
(JPY) and South Korean Won (KPW), exchange rates are quoted in 10 and 100 units,
respectively.
}

\examples{
\dontrun{
# return the foreign exchange rate (buy and sell) for USD from '2015-06-10' to
# '2015-07-10'
nrb_fx("USD", "2015-06-10", "2015-07-10")

# return the foreign exchange rate (buy and sell) for USD and EUR from
# '2015-06-10' to '2015-07-10'
nrb_fx(c("USD", "EUR"), "2015-06-10", "2015-07-10")

# draw an interactive time series chart of foreign exchange rate for USD (sell)
# from '2015-06-10' to '2015-07-10'
require(xts)
require(dygraphs)
data_fx <- nrb_fx("USD", "2015-06-10", "2015-07-10")
data_fx <- xts(data_fx[, -1], order.by = data_fx[, 1])
graph_fx <- dygraph(data_fx[data_fx$buy_sell == "sell", "fx_rate"],
                    main = "Time series graph of foreign  exchange rate for
                    USD (sell) from 2015-06-10 to 2015-07-10")
dyRangeSelector(graph_fx, height = 20, strokeColor = "darkred")
}
}
