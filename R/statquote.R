
#' @importFrom utils data
.get.sq <- function(){
  .sq.env <- new.env()
  data(quotes, package = 'statquotes', envir = .sq.env)
  .sq.env$quotes
}

#' Display a randomly chosen statistical quote.
#'
#' @param ind Integer or character.
#' If 'ind' is missing, a random quote is chosen from all quotations.
#' If 'ind' is specified and is an integer, return the ind^th quote.
#' If 'ind' is specified and is character, use it as the 'pattern'.
#'
#' @param pattern Character string. Quotes are first subset to to those which
#' match the pattern in the quote text.
#'
#' @param tag Character string. Quotes are first subset to those matching the
#' specified tag.
#'
#' @param source Character string. Quotes are first subset to those matching
#' the specified source (person).
#'
#' @param topic Deprecated. Use 'tag' instead. Only kept for backward compatability.

#' @return
#' A character vector containing one quote.
#' It is of class \code{statquote} for which an S3 print method will be invoked.
#'
#' @export
#' @importFrom stringr str_detect
#' @seealso \code{\link{quote_tags}}, \code{\link{search_quotes}}, \code{\link{quotes}},
#' Inspired by: \code{\link[fortunes:fortunes]{fortune}}
#' @examples
#' set.seed(1234)
#' statquote()
#' statquote(10)
#' statquote("boggled")
#' statquote(pattern="boggled")
#' statquote(source="Yates")
#' statquote(tag="anova")
#' print.data.frame(statquote(302)) # All information
#'
statquote <- function(ind=NULL, pattern=NULL, tag=NULL, source=NULL, topic=NULL) {

  dat <- .get.sq()

  if(!missing(topic)) {
    message("Please use `tag` instead of `topic`")
    tag=topic
  }

  # Note: is.integer(23) is FALSE, is.integer(23L) is TRUE. Make our own fun.
  isInteger <-
    function(x) is.numeric(x) && all.equal(x, as.integer(x))

  # ind is a number
  if(!missing(ind) && isInteger(ind)) {
    if (min(ind)<1 | max(ind) > nrow(dat))
      stop("ind must be between 1 and ", nrow(dat))
    dat <- dat[ind,]
  }
  # ind is string, use it as 'pattern'
  if(!missing(ind) && is.character(ind)){
    OK <- which(str_detect(tolower(dat$text), tolower(ind)))
    dat <- dat[OK,]
	  }


  # Now 'ind' is missing
  if(missing(ind) && !is.null(tag)) {
    OK <- which(str_detect(tolower(dat$tags), tolower(tag)))
    dat <- dat[OK,]
	}

  if(missing(ind) && !is.null(source) ) {
    OK <- which(str_detect(tolower(dat$source), tolower(source)))
    dat <- dat[OK,]
	}

  if(missing(ind) && !is.null(pattern) ) {
    OK <- which(str_detect(tolower(dat$text), tolower(pattern)))
    dat <- dat[OK,]
  }

  if(nrow(dat)<1) stop("No matches found")

  # Finally, pick one at random
  ind <- sample(1:nrow(dat),1)

  res <- dat[ind,]
  class(res) <- c("statquote", 'data.frame')
  return(res)
}

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
#' @param table Logical. If \code{table=TRUE}, return a one-way frequency table
#' of quotes for each tag; otherwise return the sorted vector of unique tags.
#'
#' @return Returns either a vector of tags in the quotes database or a one-way
#' frequency table of the number of quotes for each tag.
#'
#' @export
#'
#' @examples
#' quote_tags()
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
#'
quote_tags <- function (table = FALSE) {
  data <- .get.sq()
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
