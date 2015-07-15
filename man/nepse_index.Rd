\name{nepse_index}
\alias{nepse_index}
\title{Nepal Stock Exchange Index Quote}
\description{
\code{nepse_index} downloads the index/subindex values from Nepal Stock Exchange.
}

\usage{
nepse_index(index = NULL)
}
\arguments{
       \item{index}{ a character string specifying
                       the index id of the index to be loaded}
%       \item{warnings}{ boolean to turn on warnings. (TRUE)}
}
\details{
The \code{nepse_index} downloads the nepse index/sub-index for the given index
id from Nepal Stock Exchange .The \code{nepse_index} will first check
whether the entered index id is valid. The valid index id ranges from 51 to 63
and index names corresponding to these ids are Banking, Hotels, Others,
HydroPower, Development_Bank, Manufacturing, Sensitive, NEPSE, Insurance,
Finance, Trading, Float, and Sensitive_Float, respectively. The
\code{nepse_index} will return an error if the index id is not valid. The data
for valid index id starts from "2015-01-08" to the most recent transaction date.
}

\value{
\code{nepse_index} will return the object of class dataframe with 3 variables:
\code{index_date},
\code{index_name}, and
\code{index_value}
}
\references{
\url{http://www.nepalstock.com.np/}
}

\author{
Nayan Krishna Joshi
}

\examples{
\dontrun{
# index value for an invalid index id; issues an error with message
# nepse_index('70')

# index value for a valid index id; returns a dataframe
nepse_index("58")

# draw an interactive time series chart of an index value for a valid index id
require(xts)
require(dygraphs)
data_index1 <- nepse_index(58)
data_index1 <- xts(data_index1[, -1], order.by = data_index1[, 1])
nepse_index_graph <- dygraph(data_index1[, "index_value"],
                             main = "Time series graph of Nepse index")
dyRangeSelector(nepse_index_graph, height = 20, strokeColor = "darkred")

# compute daily, weekly, monthly, quartely, and yearly returns of index values
require(xts)
require(quantmod)
data_index2 <- nepse_index(58)
data_index2 <- data_index2[, c("index_date", "index_value")]
data_index2 <- xts(data_index2[, -1], order.by = data_index2[, 1])
# arithmetic returns
nepse_index_re_arithm <- allReturns(data_index2)
# logarithmic returns
nepse_index_re_log <- allReturns(data_index2, type = "log")
}
}
