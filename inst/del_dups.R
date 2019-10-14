# del_dup.R -- delete duplicated quotes and update the CSV file and the quotes.RData file
# this is just an untested sketch.

dups <- find_duplicate_quotes()

to_delete <- c(74,  # Carlyle
               89,  # Wm Watt
               110, # Box
               121, # Sherlock Holmes
               170) # Tukey

if(interactive()){
  to_delete <- c()
  for(i in 1L:length(dups)){
    print(dups[[i]])
    cat('\n ----- Which of the above should be removed? \n ----- Top quote (t), bottom quote (b), neither (n)')
    while(TRUE){
      input <- readline(prompt = "(t/b/n) > ")
      if(tolower(input) %in% c('t', 'b', 'n')) break
    }
    if(input != 'n'){
      rownums <- as.integer(rownames(dups[[i]]))
      to_delete <- c(to_delete, if(input == 't') rownums[1] else rownums[2])
    }
  }
}

# read current quotes file -- from the package root directory

qfile <- "inst/quotes.csv"

# Update the CSV file, deleting the true duplicates
quotes <- read.csv(qfile, stringsAsFactors = FALSE)
file.rename(qfile, paste0(qfile, "~"))

quotes <- quotes[-to_delete,]

write.csv(quotes, file=qfile)

source('inst/quotes2_.R')
quotes2RData()

# file.remove('inst/quotes.csv~')

