#------------------------------------------------------------------------------
#' Per Cell SD RT trimming
#'
#' \code{perCell} takes a data frame of RT data and returns trimmed rt data
#' that fall below a set standard deviation above the each condition's mean
#' (e.g., trimming all RTs slower than 2SDs of each condition's mean). This
#' function uses the group mean to calculate the cutoff criteria.
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

perCell <- function(data, minRT, sd, omitErrors = TRUE, returnType = "raw",
                    seconds = FALSE){

  # change the variable name for sd (as this is an R function)
  stDev <- sd

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


  ### do "raw"
  if(returnType == "raw"){

    # initialise variable to keep trimmed data in
    finalData <- NULL

    # loop over each condition
    for(cond in conditionList){

      # get the data, & find cutoff
      curData <- subset(trimmedData, trimmedData$condition == cond)
      curMean <- mean(curData$rt)
      curSD <- sd(curData$rt)
      curCutoff <- curMean + (stDev * curSD)

      # trim the data
      curData <- subset(curData, curData$rt < curCutoff)

      # bind the data
      finalData <- rbind(finalData, curData)
    }

    return(finalData)
  }

  ### do "mean"
  if(returnType == "mean"){

    ## first, find the cutoff for each condition, and remove the necessary
    ## trials

    # initialise variable to keep trimmed data in
    tempData <- NULL

    for(cond in conditionList){
      # get the data, & find cutoff
      curData <- subset(trimmedData, trimmedData$condition == cond)
      curMean <- mean(curData$rt)
      curSD <- sd(curData$rt)
      curCutoff <- curMean + (stDev * curSD)

      # trim the data
      curData <- subset(curData, curData$rt < curCutoff)

      # bind the data
      tempData <- rbind(tempData, curData)
    }

    # change variable names
    trimmedData <- tempData
    tempData <- NULL

    ## now loop over each subject and calculate their average
    # ready the final data set
    finalData <- matrix(0, nrow = length(participant),
                        ncol = length(conditionList))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)

    # loop over conditions & subjects and calculate their average

    # to index over conditions. It starts at 2 because this is the first column
    # in the data frame containing condition information
    j <- 2

    for(curCondition in conditionList){

      # get the current condition's data
      tempData <- subset(trimmedData, trimmedData$condition == curCondition)

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
    }

    return(finalData)

  }

  ### do "median"

  if(returnType == "median"){

    ## first, find the cutoff for each condition, and remove the necessary
    ## trials

    # initialise variable to keep trimmed data in
    tempData <- NULL

    for(cond in conditionList){
      # get the data, & find cutoff
      curData <- subset(trimmedData, trimmedData$condition == cond)
      curMean <- mean(curData$rt)
      curSD <- sd(curData$rt)
      curCutoff <- curMean + (stDev * curSD)

      # trim the data
      curData <- subset(curData, curData$rt < curCutoff)

      # bind the data
      tempData <- rbind(tempData, curData)
    }

    # change variable names
    trimmedData <- tempData
    tempData <- NULL

    ## now loop over each subject and calculate their average
    # ready the final data set
    finalData <- matrix(0, nrow = length(participant),
                        ncol = length(conditionList))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)

    # loop over conditions & subjects and calculate their average

    # to index over conditions. It starts at 2 because this is the first column
    # in the data frame containing condition information
    j <- 2

    for(curCondition in conditionList){

      # get the current condition's data
      tempData <- subset(trimmedData, trimmedData$condition == curCondition)

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
    }

    return(finalData)

  }


}
#------------------------------------------------------------------------------
