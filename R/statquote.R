.sq.env <- new.env()

#' @importFrom utils data
data(quotes, package = 'statquotes', envir = .sq.env)

.get.sq <- function() .sq.env$quotes

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
        if(i < nrow(x)) cat('\n')
      }
    } else {
      x$source <- paste("---", x$source)
      sapply(strwrap(x, width), cat, "\n")
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
#' @export

quote_topics <- function() {
  data <- .get.sq()
	levels(data[,"topic"])
}
