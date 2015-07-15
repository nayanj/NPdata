# create a dataframe of stock symbols company name, and stock id
library (httr)
library (xml2)
library (rvest)
library (curl)
library (data.table)

# get the stock_symbol and company_name
nepse_symbols_url_base <- "http://www.nepalstock.com.np/company/index/"

tem1 <- httr::POST(url = nepse_symbols_url_base, body = list(`_limit` = 500))
tem2 <- xml2::read_html(tem1)
tem3 <- rvest::html_table(tem2, fill = TRUE)
tem4 <- tem3[[1]][-c(1, 2, nrow(tem3[[1]])), 3:5]
rownames(tem4) <- 1:nrow(tem4)
names(tem4) <- c("company_name", "stock_symbol", "stock_type")

# get the id and stock_symbol
value_url_parse <- xml2::read_html(
  curl::curl("http://www.nepalstock.com.np/", handle =
               new_handle(useragent = "my_user_agent")))
stock_symbol <- rvest::html_text(
  rvest::html_nodes(
    rvest::html_node(
      value_url_parse, "#stockChartSelect"), "option")[-1])

# we want it to be integer excluding first value which corresponds to choose
# symbol
company_value <- as.integer(
  rvest::html_attr(
    rvest::html_nodes(
      rvest::html_node(
        value_url_parse, "#stockChartSelect"), "option"), "value")[-1])
tem5 <- data.frame(
  stock_symbol = stock_symbol, stock_id = company_value,
  stringsAsFactors = FALSE)

# combine tem4 and tem5 now
tem6 <- merge(tem4, tem5, by = "stock_symbol")


# get the isin from http://www.cdscnp.com/
isin_url <- "http://www.cdscnp.com/lisOfCompanies.php?type=rc"
isin_url_parse <- read_html(isin_url)
tem7 <- html_table(html_node(isin_url_parse, "table"))

# remove spaces in column 3
tem7[, 3] <- gsub("\\s+", " ", tem7[, 3])

# split third columns and generate three columns for each share type
extra_columns <- lapply(
  strsplit(tem7[, 3], "[()]"), function(x) as.data.frame(t(x)))

tem8 <- data.frame(
  cbind(tem7, data.table::rbindlist(
    lapply(extra_columns, data.table::as.data.table), fill = TRUE)),
  stringsAsFactors = FALSE)[-1]

tem8[, 3:8] <- lapply(tem8[, 3:8], as.character)
colnames(tem8) <- c("company_name", "isin_all", "isin_ordinary", "ordinary",
                    "isin_promoter", "promoter", "isin_convpref", "convpref")


# split into promoter and oridinary share and them merge and then combine back

# promoters shares tem6
tem6_prom <- tem6[tem6$stock_type == "Promotor Share", ]

# Remove Promoer Share, Promoter,Promotor Share, and Promoter share names
tem6_prom$company_name <- sub("Promoer Share",
                              "", sub("Promoter", "",
                                      sub("Promotor Share", "",
                                          sub("Promoter Share", "",
                                              tem6_prom$company_name))))
# Remove Limited,
tem6_prom$company_name <- sub("Limited|Ltd.", "", tem6_prom$company_name)

# white space remove using trimws
tem6_prom$company_name <- trimws(tem6_prom$company_name)
tem6_prom <- tem6_prom[order(tem6_prom$company_name), ]

# promoters shares tem8
tem8_prom <- tem8[!is.na(tem8$promoter), ]
tem8_prom$company_name <- sub("Limited|Ltd.", "", tem8_prom$company_name)
tem8_prom$company_name <- trimws(tem8_prom$company_name)
tem8_prom <- tem8_prom[order(tem8_prom$company_name), ]

# promoter final
tem9_prom <- merge(
  tem6_prom, tem8_prom[, c("company_name", "isin_promoter")],
  by = "company_name", all.x = TRUE)

tem9_prom$isin <- tem9_prom$isin_promoter
tem9_prom$isin_promoter <- NULL

# ordinary shares: tem6
tem6_ord <- tem6[tem6$stock_type != "Promotor Share", ]
tem6_ord$company_name <- sub("Limited|Ltd.", "", tem6_ord$company_name)

# white space remove using trimws
tem6_ord$company_name <- trimws(tem6_ord$company_name)
tem6_ord <- tem6_ord[order(tem6_ord$company_name), ]

# ordinary shares: tem8
tem8_ord <- tem8[!is.na(tem8$ordinary), ]
tem8_ord$company_name <- sub("Limited|Ltd.", "", tem8_ord$company_name)

# white space remove using trimws
tem8_ord$company_name <- trimws(tem8_ord$company_name)
tem8_ord <- tem8_ord[order(tem8_ord$company_name), ]

# ordinary final
tem9_ord <- merge(
  tem6_ord, tem8_ord[, c("company_name", "isin_ordinary")],
  by = "company_name", all.x = TRUE)

tem9_ord$isin <- tem9_ord$isin_ordinary
tem9_ord$isin_ordinary <- NULL

# rbind tem9_ord and tem9_prom
tem9 <- rbind(tem9_ord, tem9_prom)

# assign tem9 to nepse_stock_symbols

nepse_stock_symbols <- tem9
nepse_stock_symbols <- tem9[, c("company_name", "stock_type", "stock_symbol",
                                "stock_id", "isin")]

# remove all intermediate objects
rm(tem1, tem2, tem3, tem4, tem5, tem6, tem7, tem8, tem9, tem6_ord, tem6_prom,
   tem8_ord, tem8_prom, tem9_ord, tem9_prom, nepse_symbols_url_base,
   value_url_parse, stock_symbol, company_value, isin_url, isin_url_parse,
   extra_columns)

# save nepse_stock_symbols as a rda file
save(
  nepse_stock_symbols, file = paste0(
    getwd(), "/data/", "nepse_stock_symbols.rda"))
