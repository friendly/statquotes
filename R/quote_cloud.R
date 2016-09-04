#' Function to generate word cloud based upon quote database
#'
#' This function takes a search pattern (can use regular expressions) and generates
#' a word cloud based upon that filter.
#'
#' @param search A character string; used to search the database. Regular
#' expression characters are allowed. Default is to search all quotes.
#' @param max.words Logical; designate maximum number of words to be plotted.
#' @param colors A character vector pertaining to the colors to be used to designate
#' word frequency. The default is 5 levels, from light to dark green.
#' @return A wordcloud is plotted.
#' @export
#' @seealso \code{\link{statquote}}, \code{\link{quote_topics}}, \code{\link{quotes}}
#' @examples
#' make_cloud()
#' make_cloud(search = "graph")
#' make_cloud(max.words = 10)

make_cloud <- function(search = ".*", max.words = 80, colors = NA){
    library(statquotes)
    library(tidytext)
    library(dplyr)
    library(stringr)
    library(wordcloud)
    
    qt <- search_quotes(search) # defaults to all quotes
    
    data("stop_words")
    qtidy <- tbl_df(qt) %>%
        select(-source, -topic, -subtopic) %>%
        unnest_tokens(word, text) %>%
        anti_join(stop_words) %>%
        count(word, sort = TRUE)
    
    if (is.na(colors)){
      pal <- brewer.pal(9,"BuGn")
      pal <- pal[-(1:4)]
    }
    
    qtidy %>%
      with(wordcloud(word, n, max.words = max.words, colors=pal))
}

