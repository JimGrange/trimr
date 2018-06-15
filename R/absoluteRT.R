#------------------------------------------------------------------------------
#' Absolute RT trimming
#'
#' \code{absoluteRT} takes a data frame of RT data and returns trimmed rt data
#' that fall between set minimum and maximum limits.
#'
#' By passing a data frame containing raw response time data, together with
#' trimming criteria, the function will return trimmed data, either in the form
#' of trial-level data or in the form of means/medians for each subject &
#' condition.
#'
#' @param data A data frame with columns containing: participant identification
#' number ('pptVar'); condition identification, if applicable ('condVar');
#' response time data ('rtVar'); and accuracy ('accVar'). The RT can be in
#' seconds (e.g., 0.654) or milliseconds (e.g., 654). Typically, "condition"
#' will consist of strings. Accuracy must be coded as 1 for correct and 0 for
#' error responses.
#' @param minRT The lower criteria for acceptable response time. Must be in
#' the same form as rt column in data frame (e.g., in seconds OR milliseconds).
#' @param maxRT The upper criteria for acceptable response time. Must be in
#' the same form as rt column in data frame (e.g., in seconds OR milliseconds).
#' @param pptVar The quoted name of the column in the data that identifies
#' participants.
#' @param condVar The quoted name of the column in the data that includes the
#' conditions.
#' @param rtVar The quoted name of the column in the data containing reaction
#' times.
#' @param accVar The quoted name of the column in the data containing accuracy,
#' coded as 0 or 1 for incorrect and correct trial, respectively.
#' @param omitErrors If set to TRUE, error trials will be removed before
#' conducting trimming procedure. Final data returned will not be influenced
#' by errors in this case.
#' @param returnType Request nature of returned data. "raw" returns trial-
#' level data excluding trimmed data; "mean" returns mean response times per
#' participant for each experimental condition identified; "median" returns
#' median response times per participant for each experimental condition
#' identified.
#' @param digits How many decimal places to round to after trimming?
#' @examples
#' # load the example data that ships with trimr
#' data(exampleData)
#'
#' # perform the trimming, returning mean RT
#' trimmedData <- absoluteRT(data = exampleData, minRT = 150, maxRT = 2500,
#' returnType = "mean")
#'
#' @importFrom stats median sd
#'
#'
#' @export
absoluteRT <- function(data,
                       minRT,
                       maxRT,
                       pptVar = "participant",
                       condVar = "condition",
                       rtVar = "rt",
                       accVar = "accuracy",
                       omitErrors = TRUE,
                       returnType = "mean",
                       digits = 3) {

  # remove errors if the user has asked for it
  if(omitErrors == TRUE){
    trimmedData <- data[data[[accVar]] == 1, ]
  } else {
    trimmedData <- data
  }

  # get the list of participant numbers
  participant <- unique(data[[pptVar]])

  # get the list of experimental conditions
  conditionList <- unique(data[, condVar])

  # trim the data
  trimmedData <- trimmedData[trimmedData[[rtVar]] > minRT &
                               trimmedData[[rtVar]] < maxRT, ]

  # if the user asked for trial-level data, then just return what we have
  if(returnType == "raw"){
    return(trimmedData)
  }

  # if the user has asked for means, then split the data into separate
  # conditions, and display the means per condition.
  if(returnType == "mean"){

    # ready the final data set
    # make a df here to preserve ppt column
    finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                      ncol = length(conditionList)))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # loop over all conditions, and over all subjects, and find mean RT

    j <- 2 # to keep track of conditions looped over. Starts at 2 as this is
    # where the first condition's column is.

    for(currCondition in conditionList){

      # get the current condition's data
      tempData <- trimmedData[trimmedData[[condVar]] == currCondition, ]

      #now loop over all participants
      i <- 1

      for(currParticipant in participant){

        participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

        # calculate & store their mean response time
        finalData[i, j] <- round(mean(participantData[[rtVar]]), digits = digits)

        # update participant counter
        i <- i + 1
      }

      # update nCondition counter
      j <- j + 1

    } # end of condition loop

    return(finalData)

  } ## end MEAN sub-function

  # if the user has asked for medians, then split the data into separate
  # conditions, and display the medians per condition.
  if(returnType == "median"){

    # ready the final data set
    # make a df here to preserve ppt column
    finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                      ncol = length(conditionList)))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # loop over all conditions, and over all subjects, and find mean RT

    j <- 2 # to keep track of conditions looped over. Starts at 2 as this is
    # where the first condition's column is.

    for(currCondition in conditionList){

      # get the current condition's data
      tempData <- trimmedData[trimmedData[[condVar]] == currCondition, ]

      #now loop over all participants
      i <- 1

      for(currParticipant in participant){

        participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

        # calculate & store their mean response time
        finalData[i, j] <- round(median(participantData[[rtVar]]), digits = digits)

        # update participant counter
        i <- i + 1
      }

      # update nCondition counter
      j <- j + 1

    } # end of condition loop

    return(finalData)

  }

} # end of function
#------------------------------------------------------------------------------
