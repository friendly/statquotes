
# Ideas for where to find new quotes

Here are some ideas for papers and websites to review for finding quotes

% https://www.jstor.org/stable/20116653
% https://www.frontiersin.org/articles/10.3389/fnhum.2017.00390/full
% https://www.tandfonline.com/doi/full/10.1080/00031305.2018.1527253
% https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-020-01051-6
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1119478/

% See the papers at the bottom of this page: https://teachdatascience.com/pvals/


# How to contribute a quote to the statquotes package

1. Check if the quote is appropriate (is is statistical?)

2. Check if the quote is a duplicate of a quote in statquotes/data-raw/quotes_raw.txt

3. Edit the file `data-raw/quotes_raw.txt`.

Add new quotes to the bottom of the file using this format:

```
% Comment - Any text after percent sign is ignored.
quo: This is a quotation.
src: Person or persons who said or wrote the quote.
cit: Citation for the original quote (journal, book, etc).
url: URL where the quote can be found (such as journal articles).
tag: Comma-separated tags to categorize the quote.
tex: TeX-formatted citation. (mostly obsolete)
```

4. Submit a pull request.


# Package release steps

1. Run `devtools::document()`.
This will run a bit of code in the `quotes.R` file that reads `data-raw/quotes_raw.txt` and saves to `data/quotes.rda`.

2. Run `devtools::test()`

3. Run `devtools::check()`

4. Etc.
