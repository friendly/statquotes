#' Function to search quote database
#'
#' This function takes a search pattern (can use regular expressions) and returns all quotes
#' that match the pattern. If fuzzy is FALSE, then only exact matches are returned (case sensitive).
#'
#' @param search A character string, used to search the database. Regular
#'   expression characters are allowed.
#' @param fuzzy Logical; If \code{TRUE}, the function uses \code{\link[base]{agrep}} to allow approximate
#'     matches to the search string.
#' @param fields A character vector pertaining to the particular fields to search. The
#'   default is to search everything: `c("topic", "subtopic", "text", "source", "TeXsource")`.
#' @param ... additional arguments passed to \code{\link[base]{agrep}} to fine-tune fuzzy
#'   search parameters.
#' @return A data frame (also with class \code{'statquote'})
#'   object containing all quotes that match the search parameters.
#' @export
#' @seealso \code{\link[base]{agrep}}, \code{\link{statquote}}, \code{\link{quote_topics}}, \code{\link{quotes}}
#' @examples
#' search_quotes("^D") # regex to find all quotes that start with "D"
#' search_quotes("Tukey") #all quotes with "Tukey"
#' search_quotes("bad answer", fuzzy = TRUE) # fuzzy match
#'
#' # to a data.frame
#' out <- search_quotes("bad answer", fuzzy = TRUE)
#' as.data.frame(out)
#'

search_quotes <- function(search, fuzzy=FALSE,
                          fields = NULL,
                          ...) {
  data <- .get.sq()
  if(is.null(fields)) fields <- colnames(data)

  if(missing(search))
    stop("No search parameters entered.", call.=FALSE)

  merged <- data.frame(data[,fields], check.names = FALSE)
  cols <- colnames(merged)
  if (length(cols) > 1) merged <- do.call(paste, merged[,cols])

  if(fuzzy) OK <- agrep(tolower(search), tolower(merged), ...)
  else OK <- which(str_detect(merged, search))

  if (length(OK)) data <- data[OK,]
  else stop("The search parameters \'", search, "\' did not match any items.")

  class(data) <- c("statquote", 'data.frame')
  return(data)
}
