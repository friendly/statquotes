#' Function to search quote database
#'
#' This function takes a search pattern (can use regular expressions) and returns all quotes
#' that match the pattern. If fuzzy is FALSE, then only exact matches are returned (case sensitive).
#'
#' @param search A character string, used to search the database. Regular
#' expression characters are allowed.
#' @param fuzzy Logical; If \code{TRUE}, the function uses \code{\link[base]{agrep}} to allow approximate
#'     matches to the search string.
#' @return A data frame object containing all quotes that match the search
#' parameters.
#' @export
#' @seealso \code{\link[base]{agrep}}, \code{\link{statquote}}, \code{\link{quote_topics}}, \code{\link{quotes}}
#' @examples
#' search_quotes("^D") # regex to find all quotes that start with "D"
#' dat <- search_quotes("Tukey") #all quotes with "Tukey"
#' dat
#' search_quotes("bad answer", fuzzy = TRUE) # fuzzy match
#'

search_quotes <- function(search, fuzzy=FALSE) {
  data <- .get.sq()

  if(missing(search))
    stop("No search parameters entered.", call.=FALSE)

  merged <- with(data, paste(as.character(text),
                             as.character(topic),
                             as.character(subtopic),
                             as.character(source)))
  if(fuzzy) OK <- agrep(tolower(search), tolower(merged))
  else OK <- which(str_detect(merged, search))

  if (length(OK)) data <- data[OK,]
  else stop("The search parameters \'", search, "\' did not match any items.")

 return(data)
}
