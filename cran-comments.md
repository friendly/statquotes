## Test environments
* local Windows install, R 3.4.1
* win-builder R Under development (unstable) (2017-08-28 r73149)

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs

## Version 0.2.2

This version fixes a bug in the internal method used to access the statquotes data base that
appeared in more recent versions of R.  It also incorporates a few enhancements to the
basic functions

Version 0.2.2 (2017-08-29)

- Fixed a bug giving `Error in .get.sq()` in more recent versions of R.

Version 0.2.1 (2016-09-06)

- Revised output of `statquote()` to be consistent with `search_quotes()`, and allow the print
  method to display multiple quotations.

- `quote_topics()` gains a `subtopics` argument.

- export `quote_topics`

- added `as.data.frame` S2 method for `statquote`

