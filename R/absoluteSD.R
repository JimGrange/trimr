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
  if(omitErrors == TRUE){
    trimmedData <- subset(data, data$accuracy == 1)
  } else {
    trimmedData <- data
  }

  # if the data is in seconds, then set decimal places to 3, otherwise set it
  # to 0
  if(seconds == TRUE){
    digits <- 3
  } else {
    digits <- 0
  }


  # get the list of participant numbers
  participant <- unique(trimmedData$participant)

  # get the list of experimental conditions
  conditionList <- unique(trimmedData$condition)

  # trim the data to remove trials below minRT
  trimmedData <- subset(trimmedData, trimmedData$rt > minRT)

  # what is the mean & SD of the whole group's data?
  meanRT <- mean(trimmedData$rt)
  sdRT <- sd(trimmedData$rt)

  # what is the cut-off value?
  cutoff <- meanRT + (sd * sdRT)

  # remove these rts
  trimmedData <- subset(trimmedData, trimmedData$rt < cutoff)


  # if the user asked for trial-level data, return immediately to user
  if(returnType == "raw"){
    return(trimmedData)
  }

  # if the user has asked for means, then split the data into separate
  # conditions, and display the means per condition.
  if(returnType == "mean"){

    # ready the final data set
    finalData <- matrix(0, nrow = length(participant),
                        ncol = length(conditionList))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)


    # loop over all conditions, and over all subjects, and find mean RT

    j <- 2 # to keep track of conditions looped over. Starts at 2 as this is
    # where the first condition's column is.

    for(currCondition in conditionList){

      # get the current condition's data
      tempData <- subset(trimmedData, trimmedData$condition == currCondition)



      #now loop over all participants
      i <- 1

      for(currParticipant in participant){

        # get that participant's data
        participantData <- subset(tempData,
                                  tempData$participant == currParticipant)

        # calculate & store their mean response time
        finalData[i, j] <- round(mean(participantData$rt), digits = digits)

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
    finalData <- matrix(0, nrow = length(participant),
                        ncol = length(conditionList))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)


    # loop over all conditions, and over all subjects, and find mean RT

    j <- 2 # to keep track of conditions looped over. Starts at 2 as this is
    # where the first condition's column is.

    for(currCondition in conditionList){

      # get the current condition's data
      tempData <- subset(trimmedData, trimmedData$condition == currCondition)



      #now loop over all participants
      i <- 1

      for(currParticipant in participant){

        # get that participant's data
        participantData <- subset(tempData,
                                  tempData$participant == currParticipant)

        # calculate & store their mean response time
        finalData[i, j] <- round(median(participantData$rt), digits = digits)

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
