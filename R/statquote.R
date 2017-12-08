#' @importFrom utils data
.get.sq <- function(){
  .sq.env <- new.env()
  data(quotes, package = 'statquotes', envir = .sq.env)
  .sq.env$quotes
}

#' Function to display a randomly chosen statistical quote
#'
#' This function displays a randomly statistical quote from
#' a collection. The quotations are classified by topics
#'
#' @param ind Optional index of a quote; if missing a random value is sampled from
#'        the available quotations.
#' @param topic A character string, used to select a subset of the quotes based
#'        on the assigned topics.
#' @param source A character string, used to select a subset of the quotes based
#'        on the source for the quote.
#' @return A character vector containing one randomly selected quote
#'    from the included data set. It is of class \code{statquote} for
#'    which an S3 print method will be invoked.
#' @export
#' @importFrom stringr str_detect
#' @seealso \code{\link{quote_topics}}, \code{\link{search_quotes}}, \code{\link{quotes}},
#' Inspired by: \code{gaussfact} (\code{https://github.com/eddelbuettel/gaussfacts}),
#'  \code{\link[fortunes:fortunes]{fortune}}
#' @examples
#'  set.seed(1234)
#'  statquote()
#'  statquote(source="Tukey")
#'  statquote(topic="science")
#'  statquote(topic="history")
#'

statquote <- function(ind, topic=NULL, source=NULL) {

	data <- .get.sq()
	if(!missing(ind)) stopifnot(ind > 0L && ind <= nrow(data))

	if(!is.null(topic) && missing(ind)) {
	  merged <- with(data, paste(as.character(topic), as.character(subtopic)))
		OK <- which(str_detect(tolower(merged), tolower(topic)))
		if (length(OK)) data <- data[OK,]
		else warning("The topic \'", topic, "\' did not match any items and is ignored",
		             call.=FALSE)
	}

	if(!is.null(source) && missing(ind)) {
	  OK <- which(str_detect(tolower(data$source), tolower(source)))
	  if (length(OK)) data <- data[OK,]
	  else warning("The source \'", source, "\' did not match any items and is ignored",
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

#' @rdname statquote
#' @param x object of class \code{'statquote'}
#' @param width Optional column width parameter
#' @param ... Other optional arguments
#' @export

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

as.data.frame.statquote <- function(x, row.names = NULL,
                                    optional = FALSE, ...) {
  class(x) <- 'data.frame'
  x
}

#' List the topics of the quotes data base
#' @param subtopics logical; if \code{TRUE} the subtopics are printed as well
#'   with the associated topic
#' @export
#' @examples
#' quote_topics()
#' quote_topics(TRUE)

quote_topics <- function(subtopics = FALSE) {
  data <- .get.sq()
  ret <- levels(data[,"topic"])
  if(subtopics){
    subtopic_list <- lapply(ret, function(topic, data){
      lev <- levels(droplevels(data$subtopic[data$topic == topic]))
      data.frame(topic=topic, subtopic=lev)
    }, data=data)
    ret <- do.call(rbind, subtopic_list)
    ret <- ret[ret$subtopic != "", ]
  }
  ret
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

  topics <- unique(quotes$topic)
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
