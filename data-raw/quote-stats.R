#' ---
#' title: string characteristics of quotes
#' ---

library(statquotes)
library(stringr)
library(dplyr)

qt <- get_quotes()
text <- qt$text

#' ## count characters, words, sentences
stats <- data.frame(
  qid = qt$qid,
  chars = str_count(text, boundary("character")),
  words = str_count(text, boundary("word")),
  sent = str_count(text, boundary("sentence")),
  txt = substr(qt$text, 1, 40)
)

summary(stats)

#' ### histograms
hist(stats$chars)
hist(stats$words)
hist(stats$sent)

#' ### which are the longest?
stats |>
  dplyr::slice_max(words, n=12) |>
  dplyr::arrange(qid)


#' ## examine tag distribution
tags <- qt$tags
terms <- tags |> str_split(pattern = ",\\s*") |> unlist()

table(terms)

#' ## top / bottom tag terms

#' should use quote_tags(), but it doesn't allow a descending option

terms |> table() |> sort() |> as.data.frame() |> head(10)

terms |> table() |> sort(decreasing=TRUE) |> as.data.frame() |> head(10)




