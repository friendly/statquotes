.sq.env <- new.env()

.get.sq <- function() {
	quotes <- data(quotes, package="statquotes")
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
#' @return A character vector containing one randomly selected quote
#'    from the included data set. It is of class \code{statquote} for
#'    which an S3 print method will be invoked.
#' @export
#' @importFrom stringr str_detect
#' @examples
#'  set.seed(1234)
#'  statquote()
#'

statquote <- function(ind, topic=NULL) {

	if (is.null(.sq.env$quotes)) .sq.env$quotes <- .get.sq()
	data <- sq.env$quotes

	if(!is.null(topic)) {
		OK <- which(str_detect(tolower(as.character(data$topic)), tolower(topic)))
		if (length(OK)>1) data <- data[OK,]
		else warning("The topic", topic, "did not match any items and is ignored")
	}

  if (missing(ind)) {
    n <- nrow(data)
    ind <- sample(1:n, 1)
}
	res <- data[ind,]
	res <- list(text=res$text, source=res$source)
  class(res) <- "statquote"
  return(res)
}

#' @rdname statquote
#' @param x Default object for \code{print} method
#' @param width Optional column width parameter
#' @param ... Other optional arguments

print.statquote <- function(x, width = NULL, ...) {
    if (is.null(width)) width <- 0.9 * getOption("width")
    if (width < 10) stop("'width' must be greater than 10", call.=FALSE)
    x$source <- paste("---", x$source)
    invisible(sapply(strwrap(x, width), cat, "\n"))
}

#' List the topics of the quotes data base

quote_topics <- function() {
	levels(quotes[,"topic"])
}
