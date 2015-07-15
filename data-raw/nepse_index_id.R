# create a dataframe of nepse index id and nepse index name
index_id <- 51:63

index_name <- c("Banking", "Hotels", "Others", "HydroPower", "Development_Bank",
                "Manufacturing", "Sensitive", "NEPSE", "Insurance", "Finance",
                "Trading", "Float", "Sensitive_Float")

index_name <- tolower(index_name)

nepse_index_id <- data.frame(
  cbind(index_name = index_name), index_id = index_id, stringsAsFactors = FALSE)

rm(index_id, index_name)

save(nepse_index_id, file = paste0(getwd(), "/data/", "nepse_index_id.rda"))
