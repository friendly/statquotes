#' Expose the quotes data frame
#'
#' In normal use, \code{statquote} hides the quotes data in an environment.
#' This function makes the quotes data frame visible in the global environment.
#' @export
expose_quotes <- function() .get.sq()
