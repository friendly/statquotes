
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
#' @return character vector of formatted markdown quotes
#'
#' @export
#' @examples
#'
#' ll <- search_quotes("Tukey")
#' as.markdown(ll)
#'
as.markdown <- function(quotes, form = "> *%s* -- %s\n\n"){
#  topics <- unique(quotes$topic)
  lines <- sprintf(form, quotes$text, quotes$source)
  lines
}
