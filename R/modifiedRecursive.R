#------------------------------------------------------------------------------
#' modifiedRecursive trimming procedure.
#'
#' \code{modifiedRecursive} takes a data frame of RT data and returns trimmed rt
#' data that fall below a set standard deviation above the each participant's
#' mean for each condition, with the criterion changing as more trials are
#' removed,  as described in van Selst & Jolicoeur (1994).
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
#'
#' @references Van Selst, M. & Jolicoeur, P. (1994). A solution to the effect
#' of sample size on outlier elimination. \emph{Quarterly Journal of Experimental
#' Psychology, 47} (A), 631-650.
#'
#'
#' @examples
#' # load the example data that ships with trimr
#' data(exampleData)
#'
#' # perform the trimming, returning mean RT
#' trimmedData <- modifiedRecursive(data = exampleData, minRT = 150,
#' returnType = "mean")
#'
#' @importFrom stats sd
#' @importFrom dplyr %>%
#' @importFrom dplyr row_number
#' @export

modifiedRecursive <- function(data,
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
        finalData[i, j] <-
          round(modifiedRecursiveTrim(tempData[[rtVar]],
                                      returnType = returnType),
                digits = digits)

        # update condition loop counter
        j <- j + 1
      }

      # update participant loop counter
      i <- i + 1
    }

    return(finalData)

  } # end of returnType = "mean" section


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
        finalData[i, j] <-
          round(modifiedRecursiveTrim(tempData[[rtVar]],
                                      returnType = returnType),
                digits = digits)

        # update condition loop counter
        j <- j + 1
      }

      # update participant loop counter
      i <- i + 1
    }

    return(finalData)

  } # end of returnType = "median" section



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
        tempData <- modifiedRecursiveTrim(tempData, rtVar = rtVar,
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
modifiedRecursiveTrim <- function(data, rtVar = "rt", returnType = "mean"){

  # load the linear interpolation data file (hidden from user)
  criterion <- linearInterpolation

  #-------
  ### returnType == mean
  if(returnType == "mean"){

    # repeat the following
    repeat{

      # the data needs to have more than 2 RTs in order to function.
      # (thanks to Ayala Allon for noticing this.)
      if(length(data) <= 2){
        break
      }

      ### get the parameters for the moving criterion

      # get the sample size of the data
      sampleSize <- length(data)

      # if the sample size is greater than 100, use SDs for N = 100
      if(sampleSize > 100){
        sampleSize <- 100
      }

      # look up the SD to use for the current sampleSize
      rowNumber <- which(criterion$sampleSize == sampleSize)
      stDev <- criterion$modifiedRecursive[rowNumber]

      ### now do the removal of trials

      # what is the maximum RT value in the current data?
      x <- max(data)

      # temporarily remove it
      tempData <- data[data != x]

      # find the mean, SD, & cutoffs for temporary data
      curMean <- mean(tempData)
      curSD <- sd(tempData)
      maxCutoff <- curMean + (stDev * curSD)
      minCutoff <- curMean - (stDev * curSD)

      # now, go back to the main data (with temporary RTs replaced)

      # find the largest & smallest RT values
      x <- max(data)
      y <- min(data)

      # initalise this variable before looping. This will store how many trials
      # have been removed on each recursion. The loop stops when no trials
      # have been removed on a particular iteration
      removedTrials <- 0

      # if there is a data point above the cutoff, then remove it
      if(x > maxCutoff){
        data <- data[data != x]
        removedTrials <- 1
      }

      # if there is a data point below the cutoff, then remove it
      if(y < minCutoff){
        data <- data[data != y]
        removedTrials <- 1
      }

      # when there are no trials removed on the current iteration, break the
      # loop
      if(removedTrials == 0){
        break
      }

      # alternatively, stop the loop when the data set hits 4 RTs left (as in
      # vanSelst & Jolicoeur, 1994)
      if(length(data) < 5){
        break
      }

    } # end of repeat loop

    # now compute the mean of the final data set. If there are only two RTs,
    # then return NA
    if(length(data) == 2){
      finalData <- NA
    } else {
      finalData <- mean(data)
    }

    # return the data
    return(finalData)
  }


  #-------
  ### returnType == median
  if(returnType == "median"){

    # repeat the following
    repeat{

      # the data needs to have more than 2 RTs in order to function.
      # (thanks to Ayala Allon for noticing this.)
      if(length(data) <= 2){
        break
      }

      ### get the parameters for the moving criterion

      # get the sample size of the data
      sampleSize <- length(data)

      # if the sample size is greater than 100, use SDs for N = 100
      if(sampleSize > 100){
        sampleSize <- 100
      }

      # look up the SD to use for the current sampleSize
      rowNumber <- which(criterion$sampleSize == sampleSize)
      stDev <- criterion$modifiedRecursive[rowNumber]

      ### now do the removal of trials

      # what is the maximum RT value in the current data?
      x <- max(data)

      # temporarily remove it
      tempData <- data[data != x]

      # find the mean, SD, & cutoffs for temporary data
      curMean <- mean(tempData)
      curSD <- sd(tempData)
      maxCutoff <- curMean + (stDev * curSD)
      minCutoff <- curMean - (stDev * curSD)

      # now, go back to the main data (with temporary RTs replaced)

      # find the largest & smallest RT values
      x <- max(data)
      y <- min(data)

      # initalise this variable before looping. This will store how many trials
      # have been removed on each recursion. The loop stops when no trials
      # have been removed on a particular iteration
      removedTrials <- 0

      # if there is a data point above the cutoff, then remove it
      if(x > maxCutoff){
        data <- data[data != x]
        removedTrials <- 1
      }

      # if there is a data point below the cutoff, then remove it
      if(y < minCutoff){
        data <- data[data != y]
        removedTrials <- 1
      }

      # when there are no trials removed on the current iteration, break the
      # loop
      if(removedTrials == 0){
        break
      }

      # alternatively, stop the loop when the data set hits 4 RTs left (as in
      # vanSelst & Jolicoeur, 1994)
      if(length(data) < 5){
        break
      }

    } # end of repeat loop

    # now compute the mean of the final data set. If there are only two RTs,
    # then return NA
    if(length(data) == 2){
      finalData <- NA
    } else {
      finalData <- median(data)
    }

    # return the data
    return(finalData)
  }


  #-------
  ### returnType == raw
  if(returnType == "raw"){

    # repeat the following
    repeat{

      # the data needs to have more than 2 RTs in order to function.
      # (thanks to Ayala Allon for noticing this.)
      if(nrow(data) <= 2){
        break
      }

      ### get the parameters for the moving criterion

      # get the sample size of the data
      sampleSize <- nrow(data)

      # if the sample size is greater than 100, use SDs for N = 100
      if(sampleSize > 100){
        sampleSize <- 100
      }

      # look up the SD to use for the current sampleSize
      rowNumber <- which(criterion$sampleSize == sampleSize)
      stDev <- criterion$modifiedRecursive[rowNumber]

      ### now do the removal of trials

      # what is the maximum RT value in the current data?
      x <- which.max(data[[rtVar]])

      # temporarily remove it
      tempData <- data %>% filter(row_number() != x)

      # find the mean, SD, & cutoffs for temporary data
      curMean <- mean(tempData[[rtVar]])
      curSD <- sd(tempData[[rtVar]])
      maxCutoff <- curMean + (stDev * curSD)
      minCutoff <- curMean - (stDev * curSD)

      # now, go back to the main data (with temporary RTs replaced)

      # find the largest & smallest RT values
      x_pos <- which.max(data[[rtVar]])
      x <- data[x_pos, ][[rtVar]]
      y_pos <- which.min(data[[rtVar]])
      y <- data[y_pos, ][[rtVar]]

      # initalise this variable before looping. This will store how many trials
      # have been removed on each recursion. The loop stops when no trials
      # have been removed on a particular iteration
      removedTrials <- 0

      # if there is a data point above the cutoff, then remove it
      if(x > maxCutoff){
        data <- data %>% filter(row_number() != x_pos)
        removedTrials <- 1
      }

      # if there is a data point below the cutoff, then remove it
      if(y < minCutoff){
        data <- data %>% filter(row_number() != y_pos)
        removedTrials <- 1
      }

      # when there are no trials removed on the current iteration, break the
      # loop
      if(removedTrials == 0){
        break
      }

      # alternatively, stop the loop when the data set hits 4 RTs left (as in
      # vanSelst & Jolicoeur, 1994)
      if(nrow(data) < 5){
        break
      }

    } # end of repeat loop

    # now compute the mean of the final data set. If there are only two RTs,
    # then return NA
    if(nrow(data) == 2){
      finalData <- NA
    } else {
      finalData <- data
    }

    # return the data
    return(finalData)
  }

} # end of function
#------------------------------------------------------------------------------
