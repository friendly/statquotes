as.latex.statquote <- function(data){
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

  topics <- unique(data$topic)
  data$text <- symbols2tex(data$text)
  data$source <- symbols2tex(data$source)
  lines <- NULL
  if(is.null(data$TeXsource)) data$TeXsource <- ""
  for(i in 1:nrow(data)){
  	lines <- c(lines, sprintf("\\epigraph{%s}{%s}\n\n", data$text[i],
                                 if(data$TeXsource[i] != "") data$TeXsource[i] else data$source[i]))
  }
  lines
}

#' ll <- search_quotes("Tukey")
#' as.latex.statquote(ll)
