
To prepare the statquotes for publication to CRAN:

1. Edit the statquotes/data-raw/quotes_raw.txt file as desired, for example to add new quotes.

2. Note: Sometimes copy-pasting quotes from html or pdf can introduce non-ascii characters (like emdash) that cause warnings when checking the package. You can find these non-characters by searching for [[:nonascii:]].

Then proceed as normal, for example:

library(devtools)
document()
check()

