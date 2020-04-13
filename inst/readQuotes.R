#' ---
#' title: "Read and parse a quotes file in .tex or .txt format"
#' author: "Michael Friendly"
#' date: "27 March 2020"
#' ---

library(stringr)
library(magrittr)

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


readQuotes <- function(file="quotes.tex", path=".", type=c("tex", "txt")) {

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
    quotpat <- "^[^#-](.*)"               #quotes are lines that don't begin with "#" or "-"
              # FIXME:  for some reason, the first letter of the quote is not captured.
    srcpat  <- "^--+\\s+(.*)"             # sources lines with two or more "-"

    quotes <-  str_match(text, quotpat)
    source <-  str_match(text, srcpat)

  ## Tried this approach, but abandoned it...
		# # split into paragraphs, separate quote text from source
		# txt <- paste(text, collapse="\n")
		# quotes <-
		# 	strsplit(txt, "\n\n")[[1]] %>%
		# 	  str_split_fixed("\n--- ", 2) %>%
		# 	  as.data.frame() %>%
		# 	  setNames(c("text", "source"))

#browser()
		# create data frame
		# quotes <- data.frame(topic=topic,
		#                      subtopic=subtop,
		#                      text=quotes[,1],
		#                      source=quotes[,2],
		#                      stringsAsFactors=FALSE)

    quotes <- data.frame(topic=topic,
                         subtopic=subtop,
                         text=quotes[,2],
                         source=source[,2],
                         stringsAsFactors = FALSE
                         )
    # delete lines with missing text & source
    # quotes <- quotes %>%
    #   filter(!is.na(text) & !is.na(source))

    # FIXME: There is a one-off error -- text & source appear as seaprate observations

    quotes <- quotes[!(is.na(quotes$text) & is.na(quotes$source)),]
  }

  else if(type == "tex") {
    # delete non latex lines
    text <- text[str_sub(text,1,1) == "\\"]

    #str(text)

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
                         stringsAsFactors=FALSE)
  }

    quotes

}

TESTME <- FALSE

if(TESTME) {
  path <- "C:/Users/friendly/Dropbox/R/projects/statquotes/inst"
  newquotes <- readQuotes(file <- "quotes-new2.txt", path=path)

  # write as a CSV file & RData
  fname <- tools::file_path_sans_ext(file)
  outrdata <- paste0(fname, ".RData")
  outcsv   <- paste0(fname, ".csv")

  write.csv(file.path(path, outcsv))
  save(newquotes, file = file.path(path, outrdata))

  # join old and new quotes
  oldquotes <- statquotes:::.get.sq()
  qid <- max(oldquotes$qid) + 1:nrow(newquotes)
  newquotes <- cbind(qid, newquotes)
  quotes <- rbind(oldquotes, newquotes)

  # should save this directly into data/ ??
  save(quotes, file=file.path(path, "quotes.RData"))
  write.csv(quotes, file=file.path(path, "quotes.csv"), row.names=FALSE)

}
