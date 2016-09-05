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
#' quote_cloud()
#' quote_cloud(search = "graph")
#' quote_cloud(max.words = 10)

quote_cloud <- function(search = ".*", max.words = 80, colors = NA){
    library(tidytext)
    library(dplyr)
    library(wordcloud)

    qt <- search_quotes(search) # defaults to all quotes

    data("stop_words", package="tidytext")
    qtidy <- tbl_df(qt)
    qtidy <- select(qtidy, -source, -topic, -subtopic)
    qtidy <- unnest_tokens(qtidy, word, text)
    qtidy <- anti_join(qtidy, stop_words, by = "word")
    qtidy <- count(qtidy, word, sort = TRUE)

    if (is.na(colors)){
      pal <- brewer.pal(9,"BuGn")
      pal <- pal[-(1:4)]
    }

    with(qtidy, wordcloud(word, n, max.words = max.words, colors=pal))
}

