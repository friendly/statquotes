
To prepare the statquotes for publication to CRAN:

1. Edit the statquotes/data-raw/quotes_raw.txt file as desired, for example to add new quotes.

2. Note: Sometimes copy-pasting quotes from html or pdf can introduce non-ascii characters (like emdash) that cause warnings when checking the package. You can find these non-characters by searching for [[:nonascii:]].

3. Run:
   read_quotes_raw() to read and parse the quotes file, reporting missing text or source fields
   convert_quotes_txt_to_rda() to read the quotes file and write to the data/quotes.rda database

Then proceed as normal, for example:

library(devtools)
document()
check()

