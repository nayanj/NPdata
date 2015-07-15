nepse_symbols_lookup <- function(symbols = NULL) {
  # all are lower cases

  # if symbols are not supplied issue stop error
  if (missing(symbols)) {
    stop("You need to enter at least one symbol")
  }
  symbols <- toupper(symbols)

  # check whether symbols are valid by looking through nepse_stock_symbols
  valid_symbols <- symbols[
    symbols %in% NPdata::nepse_stock_symbols$stock_symbol]
  invalid_symbols <- symbols[
    !symbols %in% NPdata::nepse_stock_symbols$stock_symbol]

  length_invalid <- length(invalid_symbols)

  # stop if symbols are not valid; issue also warning

  if (length(symbols) == 1L & (length_invalid == length(symbols))) {
    stop("Symbols ", symbols, " is not valid")
  }

  if ((length(symbols) > 1L) & (length_invalid == length(symbols))) {
    stop("Symbols ", paste(symbols, collapse = ","), " are not valid")
  }
  if ((length(symbols) > 1L) & (length_invalid < length(symbols))
      & (length_invalid == 1L)) {
    warning("Symbol ", invalid_symbols, " is not valid")
  }
  if ((length(symbols) > 1L) & (length_invalid < length(symbols))
      & (length_invalid > 1L)) {
    warning("Symbols ", paste(invalid_symbols, collapse = ","), " are not valid")
  }

  # For the remainder, only valid symbols are considered
  symbols <- valid_symbols


  symbols_details <- NPdata::nepse_stock_symbols[
    NPdata::nepse_stock_symbols[["stock_symbol"]] %in% symbols, ]


  rm(length_invalid, valid_symbols, symbols)

  symbols_details

}
