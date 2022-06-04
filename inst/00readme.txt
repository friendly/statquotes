
To prepare the statquotes for publication to CRAN:

1. Edit the quotes_raw.txt file as desired, for example to add new quotes.
   Tip: Search for [[:nonascii:]] to find non-ascii characters like emdash.
   
2. Run the script convert_quotes_to_rdata.R

The proceed as normal, for example:

library(devtools)
document()
check()

