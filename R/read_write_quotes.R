# read_write_quotes.R

#' Parse quotes from the file quotes_raw.txt.
#'
#' There should be no reason for a person to call this function.
#' This function parses `data-raw/quotes_raw.txt`.
#' The resulting dataframe is then saved to `data/quotes.rda`.
#' Although it would be possible to use this function to parse
#' the quotes when loading the package, that would make it much
#' slower to load the package.
#'
#' @param file The file of raw quotes.
#'
#' @return Dataframe with quotes
#' @export
#'
read_quotes_raw <- function(file = file.path(getwd(), "data-raw/quotes_raw.txt") ) {

  rawquotes <- readLines(file)

  # Initialize dataframe
  dat <- data.frame(qid=vector("integer"),
                    text=vector("character"),
                    source=vector("character"),
                    cite=vector("character"),
                    url=vector("character"),
                    tags=vector("character"),
                    tex=vector("character")
  )
  qid=0
  numlines <- length(rawquotes)

  # Important:
  # Use gsub() instead of str_remove("^quo:", linei) because the latter
  # has errors due to parentheses

  # Allow key values to be followed by spaces (MF)
  for(i in 1:numlines){
    linei=rawquotes[i]

    if(grepl("^quo:", linei)) {
      qid=qid+1
      dat[qid,"text"] <- gsub("^quo:\\s*", "", linei)

    } else if(grepl("^src:", linei)){
      dat[qid,"source"] <- gsub("^src:\\s*", "", linei)

    } else if(grepl("^cit:", linei)){
      dat[qid,"cite"] <- gsub("^cit:\\s*", "", linei)

    } else if(grepl("^url:", linei)){
      dat[qid,"url"] <- gsub("^url:\\s*", "", linei)

    } else if(grepl("^tag:", linei)){
      dat[qid,"tags"] <- gsub("^tag:\\s*", "", linei)
      # remove trailing spaces in each tag
      # dat[qid,"tags"] <- gsub(dat[qid,"tags"], "\\s+,", ",")

    } else if(grepl("^tex:", linei)){
      dat[qid,"tex"] <- gsub("^tex:\\s*", "", linei)

    } else if(grepl("^%", linei)) {
      # comment line, do nothing
      NULL
    } else if(grepl("\\S", linei)){
      # TODO:  continuation lines _should_ be indented, or at least not begin with "^\\w+:"
      # Any other non-blank line is interpreted as a continuation
      # of the quote. This allows for structured text in quotes.
      dat[qid,"text"] <- paste0(dat[qid,"text"], "\n", linei)
    }
  }

  # add sequential qid numbers
  dat <- transform(dat, qid=1:nrow(dat) )

  message(paste("Read", nrow(dat), "quotes from ", file))

  # integrity checks

  n.na <- sum(is.na( dat[,"text"] ))
  if(n.na>0) {
    warning(paste("Found", n.na, "quotes with empty text (quo:) field"))
  }
  n.na <- sum(is.na( dat[,"source"] ))
  if(n.na>0) {
    warning(paste("Found", n.na, "quotes with empty source (src:) field"))
  }

  # return the quotes
  return(dat)

}


# This function is used in the "@eval" tag for quotes.R.
convert_quotes_txt_to_rda = function() {
  # Read the raw quotes file "data-raw/quotes_raw.txt"
  # and then export as dataframe to "data/quotes.rda"

  # Parsed data MUST be called "quotes" so that it is saved with
  # the right name (not filename)
  quotes <- read_quotes_raw()
  packdir <- getwd()
  save(quotes, file=file.path( packdir, "data/quotes.rda") )

  # A return value is REQUIRED, so use empty string
  return("")
}

