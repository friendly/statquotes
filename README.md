# statquotes [![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)]
**Quotes on statistics, data visualization and science**

This package displays a randomly chosen quotation from a data base consisting
of quotes about topics related to statistics, data visualization and science.

The data base is a collection of quotations assembled over the years from various
sources.  It began life as a simple text file and was later converted to
`LaTeX`  using the `epigraph` package. The quotes are classified by general topics (and subtopics).

In this R package, each call to `statquote()` displays a randomly selected quotation.
The selection can be restricted to those whose `topic` field matches the `topic=`
argument.

The main topics of the quotes are:

```{r}
> levels(quotes$topic)
[1] "Computing"          "Data"               "Data visualization" "History"           
[5] "Reviews"            "Science"            "Statistics"         "Unclassified"      
```

Some of these are divided into subtopics, most conveniently shown in tree form (using the [`data.tree`](https://cran.r-project.org/web/packages/data.tree/index.html) package)

<img src="qtree.png">

### Examples

```{r}
> set.seed(761)
> statquote()
The best thing about being a statistician is that you get to play in everyone's backyard. 
--- John W. Tukey 
> statquote(topic="science")
Some people weave burlap into the fabric of our lives, and some weave gold thread. Both contribute 
to make the whole picture beautiful and unique. 
--- Anon. 
```

### Installation

This package has not yet been submitted to CRAN.  It can be installed from this repo via

```
devtools::install_github("friendly/statquotes")
```

### Author

Michael Friendly  
Phil Chalmers  


### License

GPL (>= 2)
