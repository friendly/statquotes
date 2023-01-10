#' Search the quote database for a string or regex pattern
#'
#' This function takes a search pattern (or regular expression) and returns all quotes
#' that match the pattern.
#'
#' @param search     A character string or regex pattern to search the database.
#'
#' @param ignore_case If \code{TRUE}, matching is done without regard to case.
#'
#' @param fuzzy       If \code{TRUE}, use \code{\link[base]{agrep}} to allow approximate matches to the search string.
#'
#' @param fields     A character vector of the particular fields to search.
#' The default is \code{c("text","source","tags")}.
#' You can use the shortcut \code{fields="all"} to search all fields (including citation, url).
#'
#' @param ...        additional arguments passed to \code{\link[base]{agrep}} to fine-tune fuzzy search parameters.
#'
#' @return A data frame (also with class \code{'statquote'}) object containing all quotes that match the search parameters.
#'
#' @export
#' @seealso \code{\link[base]{agrep}}, \code{\link{statquote}}.
#' @examples
#' search_quotes("^D") # regex to find all quotes that start with "D"
#' search_quotes("Tukey") # all quotes with "Tukey"
#' search_quotes("Turkey", fuzzy = TRUE) # fuzzy match
#'
#' # to a data.frame
#' out <- search_quotes("bad data", fuzzy = TRUE)
#' as.data.frame(out)
#'
search_quotes <- function(search,
                          ignore_case = TRUE,
                          fuzzy = FALSE,
                          fields = c("text","source","tags"),
                          ...) {
  if(missing(search))
    stop("No search parameters entered.", call.=FALSE)

  data <- .get.sq()

  if(length(fields)==1 && fields=="all") fields <- colnames(data)

  # combine columns into single string
  merged <- apply(data[,fields,drop=FALSE],1,paste,collapse="")

  if (isTRUE(ignore_case)) {
    search <- tolower(search)
    merged <- tolower(merged)
  }

  # get position index of matches
  if(fuzzy) {
    ix <- agrep(search, merged, ...)
  } else {
    ix <- which(str_detect(merged, search))
  }

  if (length(ix)) {
    data <- data[ix,]
    class(data) <- c("statquote", 'data.frame')
    return(data)
  } else message("The search string \'", search, "\' did not match any items.")
}



#' Search the text field for a string
#'
#' @examples
#' search_text("omnibus")
#' @rdname search_quotes
#' @export
#'
search_text <- function(search, fuzzy=FALSE,
                        ...) {

  search_quotes(search = search,
                fuzzy = fuzzy,
                fields = "text",
                ...)
}

#' Retrieve the quotes database
#'
#' A convenient wrapper for search quotes that by default returns all quotes
#'
#' @return A data frame (also with class \code{'statquote'}) object
#' containing all quotes.
#'
#' @rdname search_quotes
#' @export
#' @examples
#' qdb <- get_quotes()
#' nrow(qdb)
#' names(qdb)
#'
get_quotes <- function(search = ".*", ...) {
  qt <- search_quotes(search, ...)
}
