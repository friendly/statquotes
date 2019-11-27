# Creating, updating & maintaining the `statquotes` data base

## Origin

`statquotes` originally arose from a LaTeX file, `quotes.tex`  that I used to collect interesting quotations
related to statistics, data visualization, history, software and other topics. This was designed to be a collection I could search, then copy/paste an appropriate one into a working LaTeX document.  The format
of quotes was designed to use the LaTeX `epigraph` package:

```
\epigraph{You can see a lot, just by looking.}{Yogi Berra}
\epigraph{Every picture tells a story.}{Rod Stewart, 1971}
\epigraph{A picture is worth a thousand words.}{F. Barnard, 1927}
```
Each quote has some `text` and a `source` attribution, and so could be displayed in a document something like

> *You can see a lot, just by looking.* 
> --- Yogi Berra

Overtime, I wanted to categorize these by `topic` and `subtopic`. ...


# Columns in the quotes.csv file

- topic: the general topic with which the quote relates (e.g., Science, Statistics, etc)
- subtopic (optional): the subtopic with which the quote relates within topic (e.g., Data Visualization might have 
  Pictures, Movies, etc)
- text: plain text containing the quote. Will be displayed as is in R (should follow a markdown style)
- source: the source of the quote

# Special LaTeX fields

- TeXsource (optional): Same as source, however used if special LaTeX formatting is required (e.g., \citep[p.45]{person95}). Not used in R print-out
