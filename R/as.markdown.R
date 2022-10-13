
#' Function to transform statquote objects to strings suitable for markdown
#'
#' This function coerces statquote objects to strings suitable for rendering in markdown.
#' Quotes and sources are placed within output
#' formatted via the \code{\link{sprintf}} function.
#'
#' @param quotes an object of class \code{statquote} returned from functions such as
#'   \code{\link{search_quotes}} or \code{\link{statquote}}
#'
#' @param form structure of the markdown output for the text (first argument)
#'   and source (second argument) passed to \code{\link{sprintf}}
#'
#' @param cite logical; should the \code{cite} field be included in the source output?
#'
#' @return character vector of formatted markdown quotes
#'
#' @export
#' @seealso \code{\link{as.data.frame.statquote}}, \code{\link{as.latex}}
#' @examples
#'
#' ll <- search_quotes("Tukey")
#' as.markdown(ll)
#'
as.markdown <- function(quotes,
                        form = "> *%s* -- %s\n\n",
                        cite = FALSE){
#  topics <- unique(quotes$topic)
  stopifnot('statquote' %in% class(quotes))
  if (cite) quotes$source <- ifelse(is.na(quotes$cite),
                                    quotes$source,
                                    paste0(quotes$source, ", ", quotes$cite))
  lines <- sprintf(form, quotes$text, quotes$source)
  lines
}

#' Transform quotes to tagged key:value pairs
#'
#' This function formats a statquote object to the tagged \code{key:value} format used for
#' maintaining the statquotes database.  The key names are:
#' \preformatted{
#'   quo: This is a quotation.
#'   src: Person or persons who said or wrote the quote.
#'   cit: Citation for the original quote.
#'   url: URL where the quote can be found (such as journal articles).
#'   tag: Comma-separated tags to categorize the quote.
#'   tex: TeX-formatted citation
#' }
#'
#' @param quotes an object of class \code{statquote} returned from functions such as
#'   \code{\link{search_quotes}} or \code{\link{statquote}}
#' @param qid logical. Should the quote id number `qid` be included in the output?
#'
#' @return A character vector of lines
#' @rdname as.markdown
#' @export
#'
#' @seealso \code{\link{as.data.frame.statquote}}, \code{\link{as.latex}}, \code{\link{as.markdown}}
#' @examples
#' qitems <- search_quotes("Yates")
#' cat(as.tagged(qitems[1:5,]))
#'
as.tagged <- function(quotes, qid=TRUE) {
  stopifnot('statquote' %in% class(quotes))
  fields <- c("qid", "text", "source", "cite", "url", "tags", "tex")
  lines <- NULL
  if(is.null(quotes$TeXsource)) quotes$TeXsource <- ""
  for(i in 1:nrow(quotes)){
    lines <- c(lines,
       if(qid)                       paste0("qid:", quotes$qid[i], "\n"),
                                     paste0("quo:", quotes$text[i], "\n"),
       if(!is.na(quotes$source[i]))  paste0("src:", quotes$source[i], "\n"),
       if(!is.na(quotes$cite[i]))    paste0("cit:", quotes$cite[i], "\n"),
       if(!is.na(quotes$url[i]))     paste0("url:", quotes$cite[i], "\n"),
       if(!is.na(quotes$tags[i]))    paste0("tag:", quotes$tags[i], "\n"),
       if(!is.na(quotes$tex[i]))     paste0("tex:", quotes$tex[i], "\n"),
                                     "\n"
    )
  }
  lines
}
