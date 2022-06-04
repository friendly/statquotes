# convert_quotes_to_rdata.R

library(dplyr,stringr)

# Change 'packdir' as needed
packdir <- getwd()
# packdir <- "c:/one/rpack/statquotes"

all <- readLines( file.path(packdir, "inst/quotes_raw.txt") )

dat <- data.frame(qid=vector("integer"),
                  text=vector("character"),
                  source=vector("character"),
                  citation=vector("character"),
                  url=vector("character"),
                  tags=vector("character"),
                  tex=vector("character")
                  )
qid=0
nl <- length(all)

# Use gsub() instead of str_remove("^quo:", linei) because the latter
# has errors due to parentheses

for(i in 1:nl){
  linei=all[i]

  if(str_detect(linei, "^quo:")) {
    qid=qid+1
    dat[qid,"text"] <- gsub("^quo:", "", linei)
  } else if(str_detect(linei, "^src:")){
    dat[qid,"source"] <- gsub("^src:", "", linei)
  } else if(str_detect(linei, "^cit:")){
    dat[qid,"citation"] <- gsub("^cit:", "", linei)
  } else if(str_detect(linei, "^url:")){
    dat[qid,"url"] <- gsub("^url:", "", linei)
  } else if(str_detect(linei, "^tag:")){
    dat[qid,"tags"] <- gsub("^tag:", "", linei)
  } else if(str_detect(linei, "^tex:")){
    dat[qid,"tex"] <- gsub("^tex:", "", linei)
  } else if(str_detect(linei, "^%")) {
    NULL
  } else if(str_detect(linei, "\\S")){
    # Any other non-blank line is interpreted as a continuation
    # of the quote.
    dat[qid,"text"] <- paste0(dat[qid,"text"], "\n", linei)
  }
}

  
# Checks
library(dplyr)
filter(dat, is.na(text)) # should be empty
filter(dat, is.na(source)) # should be empty

# Create rdata for the package
dat <- mutate(dat,
              qid=1:nrow(dat) )

quotes <- dat
save(quotes, file=file.path( packdir, "data/quotes.RData") )

# Alternatively, we could use 'sysdata', but that sorta hides the quotes.
## # Create sysdata for the package
## quotedata <- dat
## usethis::use_data(quotedata, internal=TRUE, overwrite=TRUE)
## if(FALSE){
##   file.info("c:/one/rpack/statquotes/R/sysdata.rda")
##   file.size("c:/one/rpack/statquotes/R/sysdata.rda") # in bytes
## }

