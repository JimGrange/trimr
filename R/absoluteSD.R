#------------------------------------------------------------------------------
#' Absolute SD RT trimming
#'
#' \code{absoluteSD} takes a data frame of RT data and returns trimmed rt data
#' that fall below a set standard deviation above the group's mean (e.g.,
#' trimming all RTs slower than 2SDs above the group mean.
#'
#' By passing a data frame containing raw response time data, together with
#' trimming criteria, the function will return trimmed data, either in the form
#' of trial-level data or in the form of means/medians.
#'
#' @param data A data frame. It must contain columns named "participant",
#' "condition", "rt", and "accuracy". The RT can be in seconds
#' (e.g., 0.654) or milliseconds (e.g., 654). Typically, "condition" will
#' consist of strings. "accuracy" must be 1 for correct and 0 for error
#' responses.
#' @param minRT The lower criteria for acceptable response time. Must be in
#' the same form as rt column in data frame (e.g., in seconds OR milliseconds).
#' All RTs below this value are removed before proceeding with SD trimming.
#' @param sd The upper criteria for standard deviation cut-off.
#' @param omitErrors If set to TRUE, error trials will be removed before
#' conducting trimming procedure. Final data returned will not be influenced
#' by errors in this case.
#' @param returnType Request nature of returned data. "raw" returns trial-
#' level data excluding trimmed data; "mean" returns mean response times per
#' participant for each experimental condition identified; "median" returns
#' median response times per participant for each experimental condition
#' identified.
#' @param seconds If set to TRUE, the response time in the data frame is
#' in seconds; retain as FALSE if your data is in millisecond form.
#' @examples
#' To do
#' @export

absoluteSD <- function(data, minRT, sd, omitErrors, returnType = "raw",
                       seconds = FALSE){

  # remove errors if the user has asked for it
  if(omiterrors == TRUE){
    trimmedData <- subset(rawdata, rawdata$accuracy == 1)
  } else {
    trimmedData <- rawdata
  }

}
