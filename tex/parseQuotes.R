#' ---
#' title: "Parse the quotes.tex file to create quotes.RData and quotes.csv"
#' author: "Michael Friendly"
#' date: "01 Sep 2016"
#' ---



# file <- "C:/Dropbox/Work2/quotes.tex"
# .Dropbox <- "C:/Users/friendly/Dropbox/"
# folder <- "Work2"
# file <- file.path(Dropbox, folder, "quotes.tex")
file <- "quotes.tex"
text <- readLines(file, encoding="UTF-8")

# useful functions
# copy a vector, duplicating previous non-NA
ditto <- function(x) {
	for (i in seq_along(x)) {
		if (!is.na(x[i]))
			last <- x[i]
		else x[i] <- last
	}
	x
}

# cleanup TeX in source field
detex <- function(x) {
  x <- str_replace(x, "%.*$", "")
  x <- str_replace(x, '``', '"')
  x <- str_replace(x, "''", '"')
  x <- str_replace(x, "\\\\&", '&')
	x <- str_replace(x, "\\\\emph\\{(.*)\\}", "\\1")
	x <- str_replace(x, "\\\\citeyear\\{(.*)\\}", "[@\\1]")
	x <- str_replace(x, "\\\\cite[pt]?\\[.*\\]?\\{(.*)\\}", "[@\\1]")
	x
}


library(stringr)

# remove blank lines & comments
text <- text[str_length(text)>1]
text <- text[str_sub(text,1,1)!="%"]
# delete non latex lines
text <- text[str_sub(text,1,1) == "\\"]

str(text)

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
# remove section headers
quotes <- quotes[!is.na(quotes[,"text"]),]
# make factors
quotes$topic <- factor(quotes$topic)
quotes$subtopic <- factor(quotes$subtopic)

# assign quote ids
quotes <- cbind(qid = 1:nrow(quotes), quotes)
# cleanup TeX stuff
quotes[,"source"] <- detex(quotes[,"source"])

# take a look
View(quotes)
str(quotes)
print(summary(quotes))

# save results
save(quotes, file="quotes.RData")
write.csv(quotes, file="quotes.csv", row.names=FALSE)

