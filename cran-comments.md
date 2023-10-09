## Test environments
* local Windows install, 4.2.3 (2023-03-15 ucrt)
* win-builder R Under development (unstable) (2023-10-08 r85282 ucrt)

## R CMD check results

There were no ERRORs, WARNINGs or NOTEs

## Reverse dependencies

There are no reverse dependencies

> devtools::revdep()
character(0)

# Version 0.3.2

This is a modest development release, enhancing display of quotations, and adding a vignette

- `as.latex()` gains a `cite` argument to include citation in the results
- `cite=TRUE` is now the default in `as.markdown()`, `as.latex()`, and  `search_quotes()`
- Collected quotes vignette added for complete overview of quotes collection

