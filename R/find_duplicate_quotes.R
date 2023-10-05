
#' Check for duplicate quotes
#'
#' Returns a list with qid, source, and the text where strings are
#' aggressively fuzzy matched.
#'
#' @importFrom stats na.omit
#' @export
#' @author Phil Chalmers
#' @examples
#'
#' # As the number of quotes has grown, this has become very slow.
#' # dups <- find_duplicate_quotes()
#'
#'
find_duplicate_quotes <- function(){
  dat <- .get.sq()
  matches <- lapply(1:nrow(dat), function(i, stringall){
    string <- stringall[i]
    tmpstring <- stringall # remove self duplicate
    tmpstring[i] <- NA
    ret <- agrep(string, tmpstring, value = FALSE)
    ret
  }, stringall = dat$text)
  whc <- which(sapply(matches, function(x) length(x) > 0L))
  matches <- cbind(whc, t(do.call(cbind, matches[whc])))

  if(nrow(matches)){
    ret <- apply(matches, 1L, function(rows){
      rows <- unique(rows)
      out <- dat[rows, ]
      out
    })
    names(ret) <- paste0('DUPLICATE_', 1L:length(ret))
    return(ret)
  }
  invisible()
}

