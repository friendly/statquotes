# del_dup.R -- delete duplicated quotes and update the CSV file and the quotes.RData file
# this is just an untested sketch.

dups <- find_duplicated_quotes()

to_delete <- c(74,  # Carlyle
               89,  # Wm Watt
               110, # Box
               121, # Sherlock Holmes
               170) # Tukey

# read current quotes file -- from the package root directory

qfile <- "inst/quotes.csv"

# Update the CSV file, deleting the true duplicates
quotes <- read.csv(qfile, stringsAsFactors = FALSE)
file.rename(qfile, paste0(qfile, "~"))

quotes <- quotes[qid %in% to_delete,]

write.csv(quotes, file=qfile)

quotes2RData()

