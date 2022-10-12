# Version 0.3.1 (2022-10-10)

- This is a major release of the `statquotes` package, now using "tags" to classify quotations rather than
the previous hierarchical system of "topics" and "subtopics".
- Many more quotations have been added and the facilities for searching and formatting have been expanded.
- Merged all `dev-tags` work into `master`
- Prepare to release
- Update README.md
- Added `as.tagged()` to reproduce input format
- Allow spaces following keys in quotes text file
- Added a few more quotes


# Version 0.3.0 (2022-06-13)

- Incorporate changes from `kwstat/statquotes` into this repo as `dev-tags` branch
- `quote_tags()` gains a `table` argument

# Version 0.2.8

- Combined all quote files into a single file: quotes_raw.txt.
- Added many quotes about hypothesis testing.
- Added 'tags' field to replace 'topic' and 'subtopic'.
- Added URLs for many quotes.
- Function `quote_topics` renamed to `quote_tags`.

# Version 0.2.7 (2022-03-14)

- add kw quotes ( #PR22)
- add Phil Chalmers & Kevin Wright as package authors

# Version 0.2.6 (2022-03-03)

- add more quotes
- `search_quotes` now uses `message()` not `stop()` on empty search
- add `search_text()` shortcut
- `search_quotes()` gets `ignore_case=TRUE`
- clean up error msgs in `statquote()`
- fix colors bug in `quote_cloud()`
- add `get_quotes()`

# Version 0.2.5 (2019-10-11)

- Added `find_duplicate_quotes()` [thx: philchalmers]
- Added hex sticker to README.md
- Added `as.markdown()` (#14)

# Version 0.2.4 (2017-12-8)

- Added as.latex() to create text output suitable for LaTeX

# Version 0.2.3 (2017-10-6)

- Created non-exported functions for adding to the quotes database [thx: philchalmers]

- Added some more quotes

# Version 0.2.2 (2017-08-29)

- Fixed a bug giving `Error in .get.sq()` in more recent versions of R.

# Version 0.2.1 (2016-09-06)

- Revised output of `statquote()` to be consistent with `search_quotes()`, and allow the print
  method to display multiple quotations.

- `quote_topics()` gains a `subtopics` argument.

- export `quote_topics`

- added `as.data.frame` S3 method for `statquote`

# Version 0.2 (2016-09-06)

- Initial release
