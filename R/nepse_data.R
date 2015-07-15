#' Stock Details for Listed Companies in NEPSE.
#'
#' The data consists of stock symbols, stock types, stock ids, and international
#'  securities identification number (isin) for all listed companies in Nepal
#'  Stock Exchange. Stock symbols, stock types, and stock ids are from
#'  \url{http://www.nepalstock.com.np/} .isin is from
#'  \url{http://www.cdscnp.com/}. Note that there are some missings for isin, as
#' some companies still have not obtained it.
#' @format A data frame with five variables:
#' \describe{
#' \item{company_name}{Name of the company listed in the NEPSE}
#' \item{stock_type}{Stock type of a listed company: ordinary share or
#' non-ordinary share}
#' \item{stock_symbol}{Stock symbol of the company listed in the NEPSE}
#' \item{stock_id}{Stock id of the company listed in the NEPSE}
#' \item{isin}{international securities identification number}
#'}
#'@source \url{http://www.nepalstock.com.np/}
"nepse_stock_symbols"

#' Stock Index ID for Index and Sub-index of NEPSE.
#'
#' The data consists of index name and index id of Nepal Stock Exchange.
#' These are from \url{http://www.nepalstock.com.np/}.
#' @format A data frame with two variables:
#' \describe{
#' \item{index_name}{Name of index or sub-index}
#' \item{index_id}{ID of index or sub_index which ranges from 51 to 63}
#' }
#'@source \url{http://www.nepalstock.com.np/}
"nepse_index_id"
