\name{nepse_symbols_lookup}
\alias{nepse_symbols_lookup}
\title{Nepal Stock Exchange Stock Symbols Lookup}
\description{
\code{nepse_symbols_lookup} returns details for stock symbols.
}
\usage{
nepse_symbols_lookup(symbols = NULL)
}
\arguments{
       \item{symbols}{ a character vector specifying
                       the names of each stock symbol to be loaded}
}
\details{
The \code{nepse_symbols_lookup} returns the name of the company listed in
Nepal Stock Exchange , stock type of a listed company (ordinary share
or non-ordinary share), stock id of the company listed in the NEPSE, and
international securities identification number (isin) for the valid stock symbol
of the company listed  in the NEPSE. For an invalid stock symbol, it stops with
an error. Stock symbols, stock types, and stock ids are from
\url{http://www.nepalstock.com.np/} and  isin is from
\url{http://www.cdscnp.com/}. Note that there are some missings
for isin, as some companies still have not obtained it.
}

\value{
\code{nepse_symbols_lookup} will return the object of class dataframe with 5
variables:
\code{company_name},
\code{stock_type},
\code{stock_symbol},
\code{stock_id}, and
\code{isin},
}
\references{
\url{http://www.nepalstock.com.np/},
\url{http://www.cdscnp.com/}
}
\author{ Nayan Krishna Joshi}


\examples{
\dontrun{
# name of company, stock_type, stock id, and isin for an invalid stock symbol
# JOSHI; issues an error with message nepse_symbols_lookup('JOSHI')

# name of company, stock_type, stock id, and isin for a valid stock symbol HBL;
# issues a non-NA dataframe
nepse_symbols_lookup("HBL")

# name of company,stock_type, stock id, and isin for an invalid stock symbol
# JOSHI and a valid stock symbol HBL; issues a non-NA dataframe for a valid stock
# symbol HBL with warning for an invalid stock symbol JOSHI.
# nepse_symbols_lookup(c('JOSHI','HBL'))
}
}
