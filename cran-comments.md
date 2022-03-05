## Test environments
* local Windows install, R 4.1.2 (2021-11-01)
* win-builder R Under development (unstable) (2022-03-03 r81847 ucrt)
* win-builder R version 4.0.5 (2021-03-31)
* rhub (Windows Server, Ubuntu Linux, ...)

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs

## Version 0.2.6 (2022-03-03)

This version fixes a number of small bugs

- add more quotes
- `search_quotes` now uses `message()` not `stop()` on empty search
- add `search_text()` shortcut
- `search_quotes()` gets `ignore_case=TRUE`
- clean up error msgs in `statquote()`
- fix colors bug in `quote_cloud()`
