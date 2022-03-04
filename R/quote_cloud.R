#' Function to generate word cloud based upon quote database
#'
#' This function takes a search pattern (can use regular expressions) and generates
#' a word cloud based upon that filter.
#'
#' @param search A character string; used to search the database. Regular
#'   expression characters are allowed. Default is to search all quotes.
#' @param max.words Logical; designate maximum number of words to be plotted.
#' @param colors A character vector pertaining to the colors to be used to designate
#'   word frequency. The default is 5 levels, from light to dark green.
#' @param ... additional arguments passed to \code{\link{search_quotes}} and
#'   \code{\link{wordcloud}}
#' @return A wordcloud is plotted.
#' @importFrom tidytext unnest_tokens
#' @importFrom wordcloud wordcloud
#' @export
#' @seealso \code{\link{statquote}}, \code{\link{quote_topics}}, \code{\link{quotes}},
#'   \code{\link{search_quotes}}. \code{\link{wordcloud}}
#' @examples
#' quote_cloud()
#' quote_cloud(search = "graph")
#' quote_cloud(max.words = 10)

quote_cloud <- function(search = ".*", max.words = 80, colors, ...){
    qt <- search_quotes(search, ...) # defaults to all quotes
    .sq.env <- new.env()
    data("stop_words", package="tidytext", envir = .sq.env)

###### dplyr approach
#     qtidy <- tbl_df(qt[,!(colnames(qt) %in% c("source", "topic", "subtopic"))])
#     qtidy <- qtidy %>% tidytext::unnest_tokens("word", "text") %>%
#       anti_join(.sq.env$stop_words, by = "word") %>%
#       count_("word", sort = TRUE)

###### base approach
    qtidy <- qt[,c("qid","text")]
    qtidy <- tidytext::unnest_tokens(qtidy, "word", "text")
    qtidy <- qtidy[!qtidy$word %in% .sq.env$stop_words$word,]
    qtidy <- as.data.frame(table(qtidy$word))
    qtidy <- qtidy[order(qtidy$Freq, decreasing = TRUE),]
    colnames(qtidy) <- c("word", "n")

    if (missing(colors))
      colors <- c("#66C2A4", "#41AE76", "#238B45", "#006D2C", "#00441B")

    with(qtidy, wordcloud::wordcloud(word, n, max.words = max.words, colors=colors, ...))
}

