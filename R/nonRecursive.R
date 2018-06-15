#------------------------------------------------------------------------------
#' nonRecursive trimming procedure.
#'
#' \code{nonRecursive} takes a data frame of RT data and returns trimmed rt
#' data that fall below a set standard deviation above the each participant's
#' mean for each condition. The SD used for trimming is proportional to the
#' number of trials in the data being passed, as described in van Selst &
#' Jolicoeur (1994).
#'
#' @param data A data frame with columns containing: participant identification
#' number ('pptVar'); condition identification, if applicable ('condVar');
#' response time data ('rtVar'); and accuracy ('accVar'). The RT can be in
#' seconds (e.g., 0.654) or milliseconds (e.g., 654). Typically, "condition"
#' will consist of strings. Accuracy must be coded as 1 for correct and 0 for
#' error responses.
#' @param minRT The lower criteria for acceptable response time. Must be in
#' the same form as rt column in data frame (e.g., in seconds OR milliseconds).
#' All RTs below this value are removed before proceeding with SD trimming.
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
#' trimmedData <- nonRecursive(data = exampleData, minRT = 150,
#' returnType = "mean")
#'
#' @references Van Selst, M. & Jolicoeur, P. (1994). A solution to the effect
#' of sample size on outlier elimination. \emph{Quarterly Journal of Experimental
#' Psychology, 47} (A), 631-650.
#'
#' @importFrom stats sd
#'
#' @export

nonRecursive <- function(data,
                         minRT,
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
  trimmedData <- trimmedData[trimmedData[[rtVar]] > minRT, ]


  #-------
  ### returnType == mean

  if(returnType == "mean"){

    # ready the final data set
    # make a df here to preserve ppt column
    finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                      ncol = length(conditionList)))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)

    # intialise looping variable for subjects
    i <- 1

    # loop over all subjects
    for(currSub in participant){

      # intialise looping variable for conditions. It starts at 2 because the
      # first column in the data file containing condition information is the
      # second one.
      j <- 2

      # loop over all conditions
      for(currCond in conditionList){

        # get the relevant data
        tempData <- trimmedData[trimmedData[[pptVar]] == currSub &
                                  trimmedData[[condVar]] == currCond, ]


        # find the average, and add to the data frame
        finalData[i, j] <- round(nonRecursiveTrim(tempData[[rtVar]],
                                                  returnType = returnType),
                                 digits = digits)

        # update condition loop counter
        j <- j + 1
      }

      # update participant loop counter
      i <- i + 1
    }
    return(finalData)
  } # end of returnType == "mean" section


  #-------
  ### returnType == median

  if(returnType == "median"){

    # ready the final data set
    # make a df here to preserve ppt column
    finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                      ncol = length(conditionList)))

    # give the columns the condition names
    colnames(finalData) <- conditionList

    # add the participant column
    finalData <- cbind(participant, finalData)

    # convert to data frame
    finalData <- data.frame(finalData)

    # intialise looping variable for subjects
    i <- 1

    # loop over all subjects
    for(currSub in participant){

      # intialise looping variable for conditions. It starts at 2 because the
      # first column in the data file containing condition information is the
      # second one.
      j <- 2

      # loop over all conditions
      for(currCond in conditionList){

        # get the relevant data
        tempData <- trimmedData[trimmedData[[pptVar]] == currSub &
                                  trimmedData[[condVar]] == currCond, ]

        # find the average, and add to the data frame
        finalData[i, j] <- round(nonRecursiveTrim(tempData[[rtVar]],
                                                  returnType = returnType),
                                 digits = digits)

        # update condition loop counter
        j <- j + 1
      }

      # update participant loop counter
      i <- i + 1
    }
    return(finalData)
  } # end of returnType == "median" section


  #-------
  ### returnType == raw
  if(returnType == "raw"){

    # ready the final data set
    finalData <- matrix(0, nrow = 0, ncol = length(colnames(trimmedData)))
    colnames(finalData) <- colnames(trimmedData)

    # loop over all subjects
    for(currSub in participant){

      # loop over each condition
      for(currCond in conditionList){

        # get the relevant data
        tempData <- trimmedData[trimmedData[[pptVar]] == currSub &
                                  trimmedData[[condVar]] == currCond, ]

        # do the trimming
        tempData <- nonRecursiveTrim(tempData[[rtVar]], rtVar = rtVar,
                                     returnType = returnType)

        # update the final data frame
        finalData <- rbind(finalData, tempData)

      }
    }

    return(finalData)

  } # end of returnType == "raw" section

}
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
### The function that acually does the trimming
nonRecursiveTrim <- function(data, rtVar = "rt", returnType = "mean"){

  # load the linear interpolation data file (hidden from user)
  criterion <- linearInterpolation

  # get the sample size of the current data
  if(returnType == "mean" | returnType == "median"){
    sampleSize <- length(data)
  } else {
    sampleSize <- nrow(data)
  }

  # if the sample size is greater than 100, use SDs for N = 100
  if(sampleSize > 100){
    sampleSize <- 100
  }

  # look up the SD to use for the current sampleSize
  rowNumber <- which(criterion$sampleSize == sampleSize)
  stDev <- criterion$nonRecursive[rowNumber]

  if(returnType == "mean" | returnType == "median"){
    # now use this value to do the trimming
    curMean <- mean(data)
    curSD <- sd(data)
    maxCutoff <- curMean + (stDev * curSD)
    minCutoff <- curMean - (stDev * curSD)

    # which trials should be included?
    includedTrials <- data < maxCutoff & data > minCutoff
  }

  if(returnType == "raw"){
    # now use this value to do the trimming
    curMean <- mean(data[[rtVar]])
    curSD <- sd(data[[rtVar]])
    maxCutoff <- curMean + (stDev * curSD)
    minCutoff <- curMean - (stDev * curSD)

    # which trials should be included?
    includedTrials <- data[[rtVar]] < maxCutoff & data[[rtVar]] > minCutoff
  }


  # organise the return data based on returnType argument
  if(returnType == "mean"){
    finalData <- mean(data[includedTrials])
  }

  if(returnType == "median"){
    finalData <- median(data[includedTrials])
  }

  if(returnType == "raw"){
    finalData <- data %>% mutate(included = includedTrials)
    finalData <- finalData %>%
      filter(included == TRUE) %>%
      select(-included)
  }


  # return it
  return(finalData)
}
#------------------------------------------------------------------------------
