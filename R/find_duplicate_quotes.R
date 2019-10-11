
#' Check for duplicates in master .csv file
#'
#' Returns a list with qid, source, and the text where strings are
#' aggressively fuzzy matched.
#'
#' @importFrom stats na.omit
#' @export
#' @author Phil Chalmers
#' @examples
#' find_duplicate_quotes()
#'
find_duplicate_quotes <- function(){
  dat <- .get.sq()
  matches <- na.omit(t(sapply(1:nrow(dat), function(i, stringall){
    string <- stringall[i]
    tmpstring <- stringall # remove self duplicate
    tmpstring[i] <- NA
    ret <- agrep(string, tmpstring, value = FALSE)
    if(!length(ret)) return(c(NA, NA))
    c(i, ret)
  }, stringall = dat$text)))

  if(nrow(matches)){
    for(i in 1:nrow(matches))
      matches[matches[i,1L] == matches[,2L], 1L] <- NA
    matches <- na.omit(matches)
    ret <- apply(matches, 1L, function(rows){
      out <- rbind(dat[rows[1], ], dat[rows[2], ])
      out[,c('qid', 'source', 'text')]
    })
    return(ret)
  }
  invisible()
}

