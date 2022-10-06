<!-- badges: start -->

[![CRAN status](https://www.r-pkg.org/badges/version/statquotes)](https://CRAN.R-project.org/package=statquotes)
[![](http://cranlogs.r-pkg.org/badges/grand-total/statquotes)](https://cran.r-project.org/package=statquotes)
[![Project Status: Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) 
[![Dependencies](https://tinyverse.netlify.com/badge/statquotes)](https://cran.r-project.org/package=statquotes)
[![Travis-CI Build Status](https://travis-ci.org/friendly/statquotes.svg?branch=master)](https://travis-ci.org/friendly/statquotes) 
[![Last Commit](https://img.shields.io/github/last-commit/friendly/statquotes)](https://github.com/friendly/statquotes)

<!-- badges: end -->


# statquotes v. 0.3.0 <img src="man/figures/statquotes-logo.png" align="right" height="200px" />
**Quotes on statistics, data visualization and science**

This package displays a randomly chosen quotation about topics related to statistics, data visualization and science.  The original idea came from the Unix `fortune` program. The `fortune` package is focused on quotes about R while the `statquotes` package is focused on quotes about data analysis and visualization.

In this R package, each call to `statquote()` displays a randomly selected quotation.  The quotes can be restricted to those whose `tags` field matches the `tag` argument, or whose `source` field matches the `source=` argument.

### Examples

```{r}
> statquote()

The best thing about being a statistician is that you get to play in everyone's backyard. 
--- John W. Tukey 

R> statquote("boggle") # or statquote(pattern="boggle")

The statistician has no magic touch by which he may come in at the stage of
tabulation and make something of nothing. Neither will his advice, however wise in
the early stages of a study, ensure successful execution and conclusion. Many a
study, launched on the ways of elegant statistical design, later boggled in
execution, ends up with results to which the theory of probability can contribute
little.
--- W. Edwards Deming

R> statquote(source="Tukey") # Choose a random quote from a specific author

Whatever the data, we can try to gain understanding by straightening or by flattening. When we
succeed in doing one or both, we almost always see more clearly what is going on.
--- John Tukey

R> statquote(tag="numeracy") # choose a random quote with a specific tag

To be numerate means to be competent, confident, and comfortable with one’s judgements on whether
to use mathematics in a particular situation and if so, what mathematics to use, how to do it,
what degree of accuracy is appropriate, and what the answer means in relation to the context.
--- Diana Coben

# To find all quotes with a particular word:
> search_quotes("lsmeans")

```

### Output formats

Quotes have class `statquote`. The `print.statquote()` method gives a plain text format for the console.
```
R> statquote("eulogy")

One is so much less than two. [John Tukey's eulogy of his wife.]
--- John Tukey
```

Use `as.markdown()` for markdown-formatted quotes:

```{r}
R> cat(as.markdown(statquote("eulogy")))
> *One is so much less than two. [John Tukey's eulogy of his wife.]* -- John Tukey
```

Use `as.latex()` for Latex-formatted quotes (for the [epigraph](https://ctan.org/pkg/epigraph) package):

```{r}
R> cat(as.latex(statquote("eulogy")))
\epigraph{One is so much less than two. [John Tukey's eulogy of his wife.]}{John Tukey}
```

Use `as.data.frame()` to see unformatted quotes:
```{r}
R> as.data.frame(statquote("eulogy"))
    qid                                                             text     source
411 411 One is so much less than two. [John Tukey's eulogy of his wife.] John Tukey
                                                                                                        cite
411 The life and professional contributions of John W. Tukey, The Annals of Statistics, 2001, Vol 30, p. 46.
     url       tags  tex
411 <NA> statistics <NA>
```


#### Quote clouds

`quote_cloud()` generates a word cloud based upon a search of the quotes database.
```{r}
#quote_cloud("bayes")
quote_cloud()
```

<img src="man/figures/quotecloud.png">

### Installation

The released CRAN version can be installed via:

```
install.packages("statquotes")
```

The development version can be installed via:
```
devtools::install_github("friendly/statquotes")
```

Please report any problems or bugs at https://github.com/friendly/statquotes/issues.

#### Quote of the day

To have `statquotes` give you an inspirational quote of the day each time you start R, edit your `.Rprofile` file:
```
# Edit .Rprofile in home directory
file.edit(file.path("~", ".Rprofile"))
```
Add this line to the bottom of `.Rprofile`, then save and close `.Rprofile`.
```
if(interactive()) statquotes::statquote()
```

### Authors

Michael Friendly,
Kevin Wright,
Phil Chalmers,
Matthew Sigal


### License

GPL (>= 2)
