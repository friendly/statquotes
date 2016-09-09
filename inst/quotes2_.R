### run this to rebuild the .Rdata file from the master csv. Must be in root dir to work
#
# quotes2RData()
quotes2RData <- function(){
  if(!file.exists('inst/quotes.csv'))
    stop(sprintf('Hey developer, are you in the root dir of statquotes?
                 It looks like you\'re here: \"%s\"', getwd()), call.=FALSE)
  data <- read.csv('inst/quotes.csv')
  data <- data.frame(qid=1L:nrow(data), data[,c('topic', 'subtopic', 'text', 'source')])
  save.image('data/quotes.RData')
  invisible(NULL)
}

### convert quotes.csv to quotes.tex (does not need to be in root)
#
# quotes2tex('quotes_test.tex') # put test file in root
# quotes2tex('tex/quotes.tex')  # replace tex file in tex/ when in root
quotes2tex <- function(filename = 'quotes.tex'){
  require(stringr)

  #replace the common csv symbols with LaTeX versions
  symbols2tex <- function(strings){
    strings <- as.character(strings)
    loc <- str_locate_all(strings, '\\*.?')
    pick <- which(sapply(loc, length) > 0)
    for(i in pick){
      index <- seq(1, nrow(loc[[i]]), by=2)
      for(j in length(index):1L)
        str_sub(strings[i], loc[[i]][index[j], 1L], loc[[i]][index[j], 1L]) <- '\\emph{'
    }
    strings <- str_replace_all(strings, '\\*', '}')
    strings <- str_replace_all(strings, ' \"', '``')
    strings
  }

  if(file.exists(filename)) file.remove(filename)
  data <- read.csv(system.file("quotes.csv", package="statquotes"))
  sink(filename)
  topics <- unique(data$topic)
  data$text <- symbols2tex(data$text)
  data$source <- symbols2tex(data$source)
  for(tpc in topics){
    tmpdat <- subset(data, topic == tpc)
    subtopics <- sort(unique(tmpdat$subtopic))
    cat(sprintf("\\section{%s}\n\n", tpc), file=filename, append=TRUE)
    for(stpc in subtopics){
      if(stpc != "")
        cat(sprintf("\\subsection{%s}\n\n", stpc), file=filename, append=TRUE)
      pick <- which(stpc == tmpdat$subtopic)
      for(i in pick)
        with(tmpdat, cat(sprintf("\\epigraph{%s}{%s}\n\n", text[i],
                                 if(TeXsource[i] != "") TeXsource[i] else source[i]),
                         file=filename, append=TRUE))
    }
  }
  sink()
  invisible(NULL)
}
