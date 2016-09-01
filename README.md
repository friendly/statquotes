# statquotes
Quotes on statistics, data visualization and science

This package displays a randomly chosen quotation from a data base consisting
of quotes about topics related to statistics, data visualization and science.

The data base is a collection of quotations assembled over the years from various
sources.  It began life as a simple text file and was later converted to
`LaTeX`  using the `epigraph` package. The quotes are classified by general topics (and subtopics).

In this R package, each call to `statquote()` displays a randomly selected quotation.
The selection can be restricted to those whose `topic` field matches the `topic=`
argument.

The topics of the quotes are:

```{r}
> levels(quotes$topic)
[1] "Computing"          "Data"               "Data visualization" "History"           
[5] "Reviews"            "Science"            "Statistics"         "Unclassified"      
```

### Author

Michael Friendly

### License

GPL (>= 2)
