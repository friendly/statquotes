#' ---
#' title: "Read and parse a quotes file in .tex or .txt format"
#' author: "Michael Friendly"
#' date: "27 March 2020"
#' ---


# useful functions
# copy a vector, duplicating previous non-NA
# [FIXME: Assumes there is no NA before the first non-NA]
ditto <- function(x) {
  for (i in seq_along(x)) {
    if (!is.na(x[i]))
      last <- x[i]
    else x[i] <- last
  }
  x
}


#' Read and parse a quotes file in LaTeX  or text format
#'
#' @param file Name of the input file; should be a `.tex` or `.txt` file
#' @param path Path to `file`
#' @param type Type of file; the default is determined by the file extension
#'
#' @return A data.frame containing the quotations.
#' @export
#'
#' @examples
readQuotes <- function(file="quotes.tex", path=".", type=c("tex", "txt")) {

  # requireNamespace("stringr")
  require(stringr)
  infile <- file.path(path, file)
  fname <- tools::file_path_sans_ext(file)
  text <- readLines(infile, encoding="UTF-8")
  if (missing(type)) type <- tools::file_ext(file)


  # remove blank lines & comments
  text <- text[str_length(text)>1]
  text <- text[str_sub(text,1,1)!="%"]

  if(type == "txt") {

    # regex to match sections and subsections
	  secpat <- "^## (.*)"
	  subpat <- "^### (.*)"
    # find them
    sects <- str_match(text, secpat)
    subsects <- str_match(text, subpat)

    # create topics and subtopics
    subsects[which(!is.na(sects[,2])),] <- ""
    topic <- ditto(sects[,2])
    subtop <- ditto(subsects[,2])

    # patterns for quotations and sources
    quotpat <- "^(\\w.*)"               # quotes are lines that begin with a word character
    srcpat  <- "^--+\\s*(.*)"           # sources lines start with two or more "-"

    quotes <-  str_match(text, quotpat)
    source <-  str_match(text, srcpat)


    quotes <- data.frame(topic=topic,
                         subtopic=subtop,
                         text=quotes[,2],
                         source=source[,2],
                         TeXsource="",
                         stringsAsFactors = FALSE
                         )

    # shift the source to be on the same line as text
    nq <- nrow(quotes)
    quotes$source[1:nq-1] <- quotes$source[2:nq]
    # delete lines with missing text & source
#    quotes <- quotes[!(is.na(quotes$text) & is.na(quotes$source)),]
    quotes <- quotes[!is.na(quotes$text),]
  }

  else if(type == "tex") {
    # delete non latex lines
    text <- text[str_sub(text,1,1) == "\\"]

    # regex to match epigraphs, sections and subsections
    secpat <- "\\\\section\\{(.*)\\}"
    subpat <- "\\\\subsection\\{(.*)\\}"
    epipat <- "\\\\epigraph\\{(.*)\\}\\{(.*)\\}"

    # find them
    sects <- str_match(text, secpat)
    subsects <- str_match(text, subpat)
    epis <- str_match(text, epipat)

    # create topics and subtopics
    subsects[which(!is.na(sects[,2])),] <- ""
    topic <- ditto(sects[,2])
    subtop <- ditto(subsects[,2])

    # create data frame
    quotes <- data.frame(topic=topic,
                         subtopic=subtop,
                         text=epis[,2],
                         source=epis[,3],
                         TeXsource="",             ## FIXME: no longer parsing this ??
                         stringsAsFactors=FALSE)
  }

    quotes

}

TESTME <- FALSE

if(TESTME) {
  # must be in project root directory!
  # if(!file.exists('inst/quotes.csv'))
  #   stop(sprintf('Hey developer, are you in the root dir of statquotes?
  #                It looks like you\'re here: \"%s\"', getwd()), call.=FALSE)

  path <- "C:/Users/friendly/Dropbox/R/projects/statquotes/inst"
  newquotes <- readQuotes(file <- "quotes-new2.txt", path=path)

  # write as a CSV file & RData
  fname <- tools::file_path_sans_ext(file)
  outrdata <- paste0(fname, ".RData")
  outcsv   <- paste0(fname, ".csv")

  write.csv(newquotes, file=file.path(path, outcsv), row.names=FALSE)
  save(newquotes, file = file.path(path, outrdata))

  # join old and new quotes
  oldquotes <- statquotes:::.get.sq()
  qid <- max(oldquotes$qid) + 1:nrow(newquotes)
  newquotes <- cbind(qid, newquotes)

  # should save this directly into data/ ??
#  save(quotes, file=file.path(path, "quotes.RData"))
  save(quotes, file=file.path("data", "quotes.RData"))

  write.csv(quotes[,-1], file=file.path(path, "quotes.csv"), row.names=FALSE)

}
