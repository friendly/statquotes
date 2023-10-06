
#' Check for duplicate quotes
#'
#' Returns a list with aggressively fuzzy matched quotations, along with their
#' relevant citation information.
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
  matches <- t(apply(matches, 1L, sort))
  matches <- matches[!duplicated(matches[,1]), , drop=FALSE]

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

