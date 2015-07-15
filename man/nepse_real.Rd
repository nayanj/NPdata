\name{nepse_real}
\alias{nepse_real}
\title{Nepal Stock Exchange Real Time Stock Quote}
\description{
\code{nepse_real} downloads the real time stock quotes from the Nepal Stock
Exchange.
}
\usage{
nepse_real(symbols = NULL)
}
\arguments{
       \item{symbols}{ a character vector specifying
                       the names of each symbol to be loaded}
%       \item{warnings}{ boolean to turn on warnings. (TRUE)}
}
\details{
The \code{nepse_real} downloads the real time stock quote for the given stock
symbol(s) from Nepal Stock Exchange. The \code{nepse_real} will first check
whether the entered symbol (s) is (are) valid stock symbol(s) by looking through
all stocks symbols listed in NEPSE. The \code{nepse_real} will return an error
if all entered symbol(s) is (are) not valid. The \code{nepse_real} will then
check whether the call is made during trading hours of the NEPSE. If the call
is not made during trading hours, it will return a dataframe with NA values
along with warning for all valid entered symbol(s). If the call is made during
trading hours, the \code{nepse_real} will then check whether valid symbol(s)
is (are) traded. For valid symbol(s) not traded, it gives NA with warning. For
example, if one of the entered symbol is not valid, then the row of dataframe
associated with that valid but not traded symbol will have NA values.
}

\value{
\code{nepse_daily} will return the object of class dataframe with 11 variables:
\code{trade_time},
\code{stock_symbol},
\code{last_trade_price},
\code{last_trade_volume},
\code{point_change},
\code{percent_change},
\code{open},
\code{high},
\code{low},
\code{volume}, and
\code{previous_closing}.
}
\references{
\url{http://www.nepalstock.com.np/}
}
\author{ Nayan Krishna Joshi}

\examples{
\dontrun{
# real time stock quote for invalid stock symbol JOSHI; issues an error with
# message nepse_real('JOSHI')

# real time stock quote for valid stock symbol HBL; if traded returns data frame
# with non-NA row
nepse_real("HBL")

# real time stock quote for valid stock symbol HBL and invalid stock symbol
# JOSHI; issues warning for an invalid symbol; for a valid symbol HBL; if traded
# , returns a data frame with single row with non-NA values
# nepse_real(c('HBL','JOSHI'))

# real time stock quote for valid stock symbols HBL and ADBL; if traded returns
# data frame non-NA rows
nepse_real(c("HBL", "ADBL"))
}
}
