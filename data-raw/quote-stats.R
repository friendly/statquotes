#' ---
#' title: string characteristics of quotes
#' ---

library(statquotes)
library(stringr)
library(dplyr)

qt <- get_quotes()
text <- qt$text

# count characters, words, sentences
stats <- data.frame(
  qid = qt$qid,
  chars = stringr::str_count(text, boundary("character")),
  words = stringr::str_count(text, boundary("word")),
  sent = str_count(text, boundary("sentence")),
  txt = substr(qt$text, 1, 40)
)

summary(stats)

hist(stats$chars)
hist(stats$words)
hist(stats$sent)

stats |>
  slice_max(words, n=10) |>
  arrange(qid)

