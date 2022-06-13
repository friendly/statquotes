
#' @importFrom utils data
.get.sq <- function(){
  .sq.env <- new.env()
  data(quotes, package = 'statquotes', envir = .sq.env)
  .sq.env$quotes
}

#' Display a randomly chosen statistical quote
#'
#' This function displays a random statistical quote.
#'
#' @param ind Integer vector of quote ID numbers.
#' If missing, a random value is sampled from all quotations.
#'
#' @param tag A character string, used to select a subset of the quotes based
#' on the tags.
#'
#' @param source A character string, used to select a subset of the quotes based
#' on the source for the quote.
#'
#' @return A character vector containing one randomly selected quote
#' from the included data set. It is of class \code{statquote} for
#' which an S3 print method will be invoked.
#'
#' @export
#' @importFrom stringr str_detect
#' @seealso \code{\link{quote_tags}}, \code{\link{search_quotes}}, \code{\link{quotes}},
#' Inspired by: \code{gaussfact} (\code{https://github.com/eddelbuettel/gaussfacts}),
#'  \code{\link[fortunes:fortunes]{fortune}}
#' @examples
#' statquote(10:11)
#' set.seed(1234)
#' statquote(123)
#' statquote(source="Tukey")
#' statquote(tag="science")
#' print.data.frame(statquote(301)) # All information, including URL
#'
statquote <- function(ind, tag=NULL, source=NULL) {

  isInteger <-
    function(x) is.numeric(x) && all.equal(x, as.integer(x))

	data <- .get.sq()
	if(!missing(ind)) {
	  if (!isInteger(ind)) stop("ind must be an integer, not '", ind, "'")
	  if (min(ind)<1 | max(ind) > nrow(data)) stop("ind must be between 1 and ", nrow(data))
	  }

	if(!is.null(tag) && missing(ind)) {
		OK <- which(str_detect(tolower(data$tags), tolower(tag)))
		if (length(OK)) {
      data <- data[OK,]
    } else warning("The tag \'", tag, "\' did not match any items and is ignored",
		             call.=FALSE)
	}

	if(!is.null(source) && missing(ind)) {
	  OK <- which(str_detect(tolower(data$source), tolower(source)))
	  if (length(OK)) {
      data <- data[OK,]
    } else warning("The source \'", source, "\' did not match any items and is ignored",
	               call.=FALSE)
	}

  if (missing(ind)) {
    n <- nrow(data)
    ind <- sample(1:n, 1)
  }

	res <- data[ind,]
  class(res) <- c("statquote", 'data.frame')
  return(res)
}

# print methods are normally not exported.  Should we stop exporting?

#' @rdname statquote
#' @param x object of class \code{'statquote'}
#' @param width Optional column width parameter
#' @param ... Other optional arguments
#' @export
#'
print.statquote <- function(x, width = NULL, ...) {
    if (is.null(width)) width <- 0.9 * getOption("width")
    if (width < 10) stop("'width' must be greater than 10", call.=FALSE)
    x <- x[ ,c('text', 'source')]
    if (nrow(x) > 1){
      for(i in 1L:nrow(x)){
        print(x[i,], width=width, ...)
      }
    } else {
      x$source <- paste("---", x$source)
      out <- c(paste0("\n", strwrap(x$text, width)),
               paste0("\n", strwrap(x$source, width)))
      sapply(out, cat)
      cat("\n")
    }
    invisible()
}

#' @rdname statquote
#' @param row.names see \code{\link{as.data.frame}}
#' @param optional see \code{\link{as.data.frame}}
#' @export
#'
as.data.frame.statquote <- function(x, row.names = NULL,
                                    optional = FALSE, ...) {
  class(x) <- 'data.frame'
  x
}

#' List the tags of the quotes database
#'
#' List the tags of the quotes database
#'
#' @param table logical; if \code{table=TRUE} returns a one-way frequency table of quotes for each tag; otherwise
#'        returns the sorted vector of unique tags.
#'
#' @return Returns either the list of tags in the quotes database or a one-way frequency table of the number of
#'        quotes for each tag.
#' @export
#'
#' @examples
#' quote_tags()
#'
#' quote_tags(table=TRUE)
#'
#' library(ggplot2)
#' qt <- quote_tags(table=TRUE)
#' qtdf <-as.data.frame(qt)
#' # bar plot of frequencies
#' ggplot2::ggplot(data=qtdf, aes(x=Freq, y=tags)) +
#'     geom_bar(stat = "identity")
#'
#' # Sort tags by frequency
#' qtdf |>
#'   dplyr::mutate(tags = forcats::fct_reorder(tags, Freq)) |>
#'   ggplot2::ggplot(aes(x=Freq, y=tags)) +
#'   geom_bar(stat = "identity")

quote_tags <- function (table = FALSE)
{
  data <- statquotes:::.get.sq()
  tags <- data[, "tags"]
  tags <- unlist(strsplit(tags, ","))
  tabs <- tags[!is.na(tags)]
  if (table) {
    table(tags)
  }
  else {
    tags <- unique(tags)
    sort(tags)
  }
}
#' Function coerces statquote objects to strings suitable for LaTeX
#'
#' This function coerces statquote objects to strings suitable for rendering in LaTeX.
#' Quotes and (potential LaTeX) sources are placed within suitable "\code{epigraph}" output
#' format via the \code{\link{sprintf}} function.
#'
#' @param quotes an object of class \code{statquote} returned from functions such as
#'   \code{\link{search_quotes}} or \code{\link{statquote}}
#'
#' @param form structure of the LaTeX output for the text (first argument)
#'   and source (second argument) passed to \code{\link{sprintf}}
#'
#' @return character vector of formatted LaTeX quotes
#'
#' @export
#' @examples
#'
#' ll <- search_quotes("Tukey")
#' as.latex(ll)
#'

as.latex <- function(quotes, form = "\\epigraph{%s}{%s}\n\n"){

  stopifnot('statquote' %in% class(quotes))
  #replace the common csv symbols with LaTeX versions
  symbols2tex <- function(strings){
    strings <- as.character(strings)
    loc <- stringr::str_locate_all(strings, '\\*.?')
    pick <- which(sapply(loc, length) > 0)
    for(i in pick){
      index <- seq(1, nrow(loc[[i]]), by=2)
      for(j in length(index):1L)
        stringr::str_sub(strings[i], loc[[i]][index[j], 1L], loc[[i]][index[j], 1L]) <- '\\emph{'
    }
    strings <- stringr::str_replace_all(strings, '\\*', '}')
    strings <- stringr::str_replace_all(strings, ' \"', '``')
    strings
  }

  quotes$text <- symbols2tex(quotes$text)
  quotes$source <- symbols2tex(quotes$source)
  lines <- NULL
  if(is.null(quotes$TeXsource)) quotes$TeXsource <- ""
  for(i in 1:nrow(quotes)){
    lines <- c(lines, sprintf(form, quotes$text[i],
                              if(quotes$TeXsource[i] != "") quotes$TeXsource[i] else quotes$source[i]))
  }
  lines
}
