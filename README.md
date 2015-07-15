# NPdata
The R `NPdata` package provides functions to automate downloading financial and economic data available through 
different official Government of Nepal (GoN) websites. Currently, the package allows you to download data 
from two sources: 
* [Nepal Stock Exchange](http://www.nepalstock.com.np/) for stock market data:
 * real time stock quotes during trading hours of Nepal Stock Exchange
 * daily historical stock prices and volumes beginning from May 9, 2010
 * daily historical indexes beginning from January 8, 2015
 * daily historical floor sheets beginning from July 13, 2014
* [Nepal Rastra Bank](http://www.nrb.org.np/) for foreign exchange rates : 
 * daily historical foreign exchange rates beginning from January 1, 2000. 

### Installation and Dependencies
```r
# # NPdata depends on a couple of R packages. Those are automatically installed when installing 
# # NPdata by the following command in R
# # install.packages("devtools") : if not installed 
library(devtools)
install_github("nayanj/NPdata")
```
### How to file a bug report
If you encounter an issue with `NPdata`, please [submit a bug report](https://github.com/nayanj/NPdata/issues) with a minimal reproducible example. 

### Examples

Real Time Stock Quotes for Nepal Bank Limited (NBL) and Himalyan Bank Limited (HBL) on July 14, 2014 at 
at Nepal Standard Time (NST) 14:08:36 

```r
# # Only should be called during trading hours (12 PM to 3 PM NST) and trading days (Monday to Thursday) 
# # (excluding public holidays) of Nepal Stock Exchange 
library(NPdata)
nepse_real(symbols = c("NBL","HBL")) 
# trade_time stock_symbol last_trade_price last_trade_volume point_change percent_change open high low volume previous_closing
# 1 2015-07-14 14:08:36          HBL              810               139           -6           0.74  816  816 810   1332              816
# 2 2015-07-14 14:08:36          NBL              275              2000           -2           0.72  272  276 270  12100              277```
```


Daily Stock Quote for Nepal Bank Limited (NBL) for July 12, 2015
```r
# # To download the daily stock quote from the Nepal Stock Exchange. 
library(NPdata)
nepse_daily(symbol = "NBL", date = "2015-07-12") 
# daily_date stock_symbol transaction_no max_price min_price closing_price traded_shares  amount previous_closing difference
# 1 2015-07-12          NBL             22       282       270           273         16774 4607889              280          7
```

Floor sheet data for Nepal Bank Limited (NBL) from July 12, 2015 to July 13, 2015
```r
library(NPdata)
nepse_floor(symbol = "NBL", from = "2015-07-12", to = "2015-07-13") 
# floor_date stock_symbol     contract_no buyer_broker seller_broker quantity rate  amount
# 1  2015-07-12          NBL 201507122614102           44            44     3000  270  810000
# 2  2015-07-12          NBL 201507122614101           44            44      500  275  137500
# 3  2015-07-12          NBL 201507122614106           44            44      500  275  137500
# 4  2015-07-12          NBL 201507122614260           32            50      283  278   78674
# 5  2015-07-12          NBL 201507122614420           21             8     1000  277  277000
# 6  2015-07-12          NBL 201507122614448           21            34      500  277  138500
# 7  2015-07-12          NBL 201507122614595            6             6       50  282   14100
# 8  2015-07-12          NBL 201507122614726           25            25       20  278    5560
# 9  2015-07-12          NBL 201507122614803           33            33     1320  279  368280
# 10 2015-07-12          NBL 201507122614936           42            44     1000  276  276000
# 11 2015-07-12          NBL 201507122614944           41            20     1000  275  275000
# 12 2015-07-12          NBL 201507122615004           51            20     1256  275  345400
# 13 2015-07-12          NBL 201507122615018           14            44      500  276  138000
# 14 2015-07-12          NBL 201507122615125           13            20      800  275  220000
# 15 2015-07-12          NBL 201507122615139           17            44      200  280   56000
# 16 2015-07-12          NBL 201507122615156           16            20      970  275  266750
# 17 2015-07-12          NBL 201507122615181           40            21      500  275  137500
# 18 2015-07-12          NBL 201507122615221           32            20      875  275  240625
# 19 2015-07-12          NBL 201507122615289           47            44      500  275  137500
# 20 2015-07-12          NBL 201507122615286           29            44      500  275  137500
# 21 2015-07-12          NBL 201507122615294           51            44      500  275  137500
# 22 2015-07-12          NBL 201507122615444           47            53     1000  273  273000
# 23 2015-07-13          NBL 201507132615530           11            44      500  270  135000
# 24 2015-07-13          NBL 201507132615531           44            44     5000  265 1325000
# 25 2015-07-13          NBL 201507132615534           22            44      100  270   27000
# 26 2015-07-13          NBL 201507132615536           41            44      100  275   27500
# 27 2015-07-13          NBL 201507132615842           35            44     1000  275  275000
# 28 2015-07-13          NBL 201507132615841           32            44       20  275    5500
# 29 2015-07-13          NBL 201507132615922           47            44     1000  274  274000
# 30 2015-07-13          NBL 201507132616253           47             8      670  276  184920
# 31 2015-07-13          NBL 201507132616271           47            10      500  275  137500
# 32 2015-07-13          NBL 201507132616428            8            10      500  277  138500
# 33 2015-07-13          NBL 201507132616606            7            44     1000  275  275000
# 34 2015-07-13          NBL 201507132616624           36            44      300  275   82500
# 35 2015-07-13          NBL 201507132616737           42            21      500  277  138500
```

Historical Daily Index/Sub-Index Values for NEPSE Index

```r
# # NEPSE Index has an index value of 58; this downloads the data beginning from January 8, 2015. 
library(NPdata)
data_nepse <- nepse_index(index = "58")
head(data_nepse, 10)
# index_date index_name index_value
# 1  2015-01-13      nepse      937.48
# 2  2015-01-14      nepse      939.53
# 3  2015-01-18      nepse      945.36
# 4  2015-01-19      nepse      975.45
# 5  2015-01-20      nepse      962.80
# 6  2015-01-22      nepse      959.24
# 7  2015-01-25      nepse      969.05
# 8  2015-01-26      nepse      968.63
# 9  2015-01-27      nepse      975.14
# 10 2015-01-28      nepse      988.07
```

Stock Details for Stock Symbols HBL and NBL

```r
# # This returns company_name, stock type, stock id, and international securities identification 
# # number (isin) along with stock symbols
library(NPdata)
nepse_symbols_lookup(symbols = c("HBL","NBL"))
# company_name       stock_type stock_symbol stock_id          isin
# 74  Himalayan Bank Commercial Banks          HBL      134 NPE019A00007 
# 147     Nepal Bank Commercial Banks          NBL      517 NPE026A00002 
```

Buy and Sell Foreign Exchange Rates for US Dollar (USD) and EURO (EUR) from June 6, 2015 to June 13, 2015

```r
# # This downloads data from Nepal Rastra Bank 
library(NPdata)
nrb_fx(fx_codes = c("USD", "EUR"), from = "2015-06-10", to = "2015-07-10")
# fx_date fx_codes buy_sell fx_rate
# 1  2015-06-10      usd      buy  101.96
# 2  2015-06-11      usd      buy  101.84
# 3  2015-06-12      usd      buy  102.04
# 4  2015-06-13      usd      buy  102.24
# 5  2015-06-10      usd     sell  102.56
# 6  2015-06-11      usd     sell  102.44
# 7  2015-06-12      usd     sell  102.64
# 8  2015-06-13      usd     sell  102.84
# 9  2015-06-10      eur      buy  114.97
# 10 2015-06-11      eur      buy  115.08
# 11 2015-06-12      eur      buy  114.86
# 12 2015-06-13      eur      buy  114.24
# 13 2015-06-10      eur     sell  115.65
# 14 2015-06-11      eur     sell  115.76
# 15 2015-06-12      eur     sell  115.53
# 16 2015-06-13      eur     sell  114.91
```
