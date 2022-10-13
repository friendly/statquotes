#' ---
#' title: convert_quotes_to_rda.R
#' ---

#' This script reads `data-raw/quotes_raw.txt`, converts the quotes into an R data.frame,
#' and writes the data.frame to `data/quotes.rda`
#'
#' Modified: 10.12/22 MF -- made the body of the script into a function, readQuotes
#' Invoke it after the function has been read in
#' TODO: make the function a separate R file, with options to write the new quotes database.

library(dplyr)
library(stringr)

#rawquotes <- readLines( file.path(packdir, "data-raw/quotes_raw.txt") )

readQuotes <- function(file) {

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

    if(str_detect(linei, "^quo:")) {
      qid=qid+1
      dat[qid,"text"] <- gsub("^quo:\\s*", "", linei)

    } else if(str_detect(linei, "^src:")){
      dat[qid,"source"] <- gsub("^src:\\s*", "", linei)

    } else if(str_detect(linei, "^cit:")){
      dat[qid,"cite"] <- gsub("^cit:\\s*", "", linei)

    } else if(str_detect(linei, "^url:")){
      dat[qid,"url"] <- gsub("^url:\\s*", "", linei)

    } else if(str_detect(linei, "^tag:")){
      dat[qid,"tags"] <- gsub("^tag:\\s*", "", linei)
      # remove trailing spaces in each tag
      # dat[qid,"tags"] <- gsub(dat[qid,"tags"], "\\s+,", ",")

    } else if(str_detect(linei, "^tex:")){
      dat[qid,"tex"] <- gsub("^tex:\\s*", "", linei)

    } else if(str_detect(linei, "^%")) {
      # comment line, do nothing
      NULL
    } else if(str_detect(linei, "\\S")){
      # TODO:  continuation lines _should_ be indented, or at least not begin with "^\\w+:"
      # Any other non-blank line is interpreted as a continuation
      # of the quote. This allows for structured text in quotes.
      dat[qid,"text"] <- paste0(dat[qid,"text"], "\n", linei)
    }
  }

  # add sequential qid
  dat <- mutate(dat,
                qid=1:nrow(dat) )

  # checks
  empty_text <- filter(dat, is.na(source))
  if (nrow(empty_text) > 0) {
    warning(paste("found", nrow(empty_text), "quotes with empty text (quo:) field"))
  }
  empty_source <- filter(dat, is.na(source))
  if (nrow(empty_source) > 0) {
    warning(paste("found", nrow(empty_src), "quotes with empty source (src:) field"))
  }

  message(paste("Read", nrow(dat), "quotes from ", file))
  # return the quotes
  dat

}

# Change 'packdir' as needed
packdir <- getwd()
# packdir <- "c:/one/rpack/statquotes"
qdata <- readQuotes(file.path(packdir, "data-raw/quotes_raw.txt") )

# Checks
head(qdata)
tail(qdata)
# filter(qdata, is.na(text)) # should be empty
# filter(qdata, is.na(source)) # should be empty

# Create rdata for the package

quotes <- qdata
save(quotes, file=file.path( packdir, "data/quotes.rda") )

# We could have used 'sysdata' instead, but that hides the quotes data object
## # Create sysdata for the package
## quotedata <- dat
## usethis::use_data(quotedata, internal=TRUE, overwrite=TRUE)
## if(FALSE){
##   file.info("c:/one/rpack/statquotes/R/sysdata.rda")
##   file.size("c:/one/rpack/statquotes/R/sysdata.rda") # in bytes
## }

