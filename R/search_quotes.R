#' Function to search quote database
#'
#' This function takes a search pattern (can use regular expressions) and returns all quotes
#' that match the pattern. If fuzzy is FALSE, then only exact matches are returned (case sensitive).
#'
#' @param search A character string, used to search the database. Regular
#' expression characters are allowed.
#' @return A data frame object containing all quotes that match the search
#' parameters.
#' @export
#' @importFrom stringr str_detect
#' @seealso \code{\link{statquote}}, \code{\link{quote_topics}}, \code{\link{quotes}}
#' @examples
#' search_quotes("^D") # regex to find all quotes that start with "D"
#' dat <- search_quotes("Tukey")
#' dat
#'

search_quotes <- function(search=NULL, fuzzy=FALSE) {
  data <- .get.sq()

  if(is.null(search)) {
    stop("No search parameters entered.")
  }

  merged <- with(data, paste(as.character(text),
                             as.character(topic),
                             as.character(subtopic),
                             as.character(source)))
  if(fuzzy) OK <- agrep(tolower(search), tolower(merged))
  else OK <- which(str_detect(merged, search))

  if (length(OK)>1) data <- data[OK,]
  else stop("The search parameters \'", search, "\' did not match any items.")

 return(data)
}
