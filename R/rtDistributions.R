###
# functions for finding response time cumulative distribution functions (CDFs)


#------------------------------------------------------------------------------
#' Find cumulative distribution function (CDF) values for a single condition
#'
#' \code{cdf} takes a data frame for a single experimental condition and
#' returns a vector of requested CDF values.
#'
#' The function only deals with one experimental condition. There is another
#' function (\code{cdfAll}) which will return CDFs for all experimental
#' conditions. If there are more than one subject in the data frame being
#' passed to this function, the function first finds the CDF values for each
#' subject, and then takes the average for each quantile. This average is then
#' returned to the user.
#'
#' @param data A data frame containing the data to be passed to the function.
#' At the very least, the data frame must contain columns named "accuracy"
#' logging the accuracy (1 for correct, 0 for error) and "rt" containing the
#' response time data. If the user wishes to find the average CDFs across
#' multiple subjects, then another column must be included ("subject") with
#' numbers identifying unique subjects. See \code{?exampleData} for a data
#' frame formatted correctly.
#'
#' @param quantiles The quantile values to be found by the function. By
#' default, the function finds the .1, .3, .5, .7, and .9 CDF values.
#'
#' @param correctTrials If set to 1, the function will find the CDFs of
#' correct trials. Set to 2 to find the CDFs of error trials. Set to 3 to find
#' CDFs of ALL trials. Note, though, that CDFs of error trials may be less
#' accurate due to usually-low number of error trials.
#'
#' @param multipleParticipants Inform the function whether the data frame contains
#' data from multiple participants. If set to TRUE, the function returns the
#' average CDF values across all participants. If set to FALSE, the function
#' assumes all data being passed is just from one participant.
#'
#'
#' @examples
#' ### example of multiple subjects and default quantile values
#'
#' # only select the congruent data from the example data set
#' data <- subset(exampleData, exampleData$congruency == "congruent")
#'
#' # get the CDFs
#' getCDF <- cdf(data)
#'
#' ### example of single participant and different quantile values
#'
#' # only select subject 1 from the example data. Also, select only the
#' # "absent" condition and incongruent trials. This is an example when working
#' # with multiple conditions (besides target congruency).
#' data <- subset(exampleData, exampleData$participant == 1 &
#'     exampleData$condition == "absent" &
#'     exampleData$congruency == "incongruent")
#'
#' # set new quantile values
#' newQuantiles <- c(.1, .2, .3, .4, .5, .6, .7, .8,  .9)
#'
#' # get the CDFs
#' getCDF <- cdf(data, quantiles = newQuantiles, multipleParticipants = FALSE)
#'

#' @export
cdf <- function(data, quantiles = c(.1, .3, .5, .7, .9),
                correctTrials = 1, multipleParticipants = TRUE){

  # perform the simple operation of calculating CDFs if only one participant
  if(multipleParticipants == FALSE){


    # select whether the user wants correct trials or error trials (or all!)
    if(correctTrials == 1){
      tempData <- subset(data, data$accuracy == 1)
    }
    if(correctTrials == 2){
      tempData <- subset(data, data$accuracy == 0)
    }
    if(correctTrials == 3){
      tempData <- data
    }

    # calculate the CDFs
    cdfs <- as.numeric(quantile(tempData$rt, quantiles))

    # return them to the user
    return(cdfs)
  }


  # if there are multiple participants, find average CDF across these
  if(multipleParticipants == TRUE){

    # find the unique participant numbers
    subs <- unique(data$participant)

    # how many participants are there?
    nSubs <- length(subs)

    # create a n*m matrix where rows (n) reflect quantile, and columns (m) are
    # participants. At the end, return the average of each row (quantile)
    cdfData <- matrix(0, nrow = length(quantiles), ncol = nSubs)

    # loop over all participants, find their CDFs, and place in cdfData matrix
    for(i in 1:nSubs){

      tempData <- subset(data, data$participant == subs[i])

      # select whether the user wants correct trials or error trials (or all!)
      if(correctTrials == 1){
        tempData <- subset(data, data$accuracy == 1)
      }
      if(correctTrials == 2){
        tempData <- subset(data, data$accuracy == 0)
      }
      if(correctTrials == 3){
        tempData <- data
      }


      # log the result
      cdfData[, i] <- quantile(tempData$rt, quantiles)

    }

    #calculate average CDFs across subjects
    averageCDF <- apply(cdfData, 1, mean)

  }

  # return them to the user
  return(averageCDF)

}
#------------------------------------------------------------------------------



#------------------------------------------------------------------------------
#' Find conditional accuracy function (CAF) values for a single condition
#'
#' \code{caf} takes a data frame for a single experimental condition and
#' returns a vector of requested conditional accuracty function (CAF) values.
#'
#' The function only deals with one experimental condition. There is another
#' function (\code{cafAll}) which will return CAFs for all experimental
#' conditions. If there are more than one participant in the data frame being
#' passed to this function, the function first finds the CAF values for each
#' participant, and then takes the average for each quantile. This average is
#' then returned to the user.
#'
#' @param data A data frame containing the data to be passed to the function.
#' At the very least, the data frame must contain columns named "accuracy"
#' logging the accuracy (1 for correct, 0 for error) and "rt" containing the
#' response time data. If the user wishes to find the average CAFs across
#' multiple participants, then another column must be included ("participant")
#' with numbers identifying unique participants.
#' See \code{?exampleData} for a data frame formatted correctly.
#'
#' @param quantiles The quantile values to be found by the function. By
#' default, the function finds the accuracy for the .25, .5, and .75 quantiles.
#'
#' @param multipleParticipants Inform the function whether the data frame contains
#' data from multiple participants. If set to TRUE, the function returns the
#' average CAF values across all participants. If set to FALSE, the function
#' assumes all data being passed is just from one participant.
#'
#'
#' @examples
#' ### example of multiple participants and default quantile values
#'
#' # only select the congruent data from the example data set
#' data <- subset(exampleData, exampleData$congruency == "congruent")
#'
#' # get the CDFs
#' getCAF <- caf(data)
#'
#' ### example of single participant and different quantile values
#'
#' # only select participant 1 from the example data. Also, select only the
#' # "absent" condition and incongruent trials. This is an example when working
#' # with multiple conditions (besides target congruency).
#' data <- subset(exampleData, exampleData$participant == 1 &
#'     exampleData$condition == "absent" &
#'     exampleData$congruency == "incongruent")
#'
#' # set new quantile values
#' newQuantiles <- c(.2, .4, .6, .8)
#'
#' # get the CAFs
#' getCAF <- caf(data, quantiles = newQuantiles, multipleParticipants = FALSE)
#'

#' @export
caf <- function(data, quantiles = c(.25, .50, .75), multipleParticipants = TRUE){

  # single participant---------------------------------------------------------
  # perform simple CAF calculation if only one participant is being passed
  # to the function
  if(multipleParticipants == FALSE){

    # initialise empty vector to store data
    cafData <- numeric(length = (length(quantiles) * 2) + 2)

    # get the RT values for quantile cut-offs
    cdfs <- quantile(data$rt, quantiles)

    # calculate mean RT and proportion error for each bin----------------------
    for(i in 1:length(quantiles)){

      ## do the first one manually
      if(i == 1){
        # get the data
        temp <- subset(data, data$rt < cdfs[i])
        # log the RT
        cafData[i] <- mean(temp$rt)
        # log the accuracy
        cafData[i + length(quantiles) + 1] <- sum(temp$accuracy) /
          length(temp$accuracy)
      }

      ## do the rest of the slots automatically
      if(i > 1 & i <= length(quantiles)){

        # get the data
        temp <- subset(data, data$rt > cdfs[i - 1] & data$rt < cdfs[i])
        # log the RT
        cafData[i] <- mean(temp$rt)
        # log the accuracy
        cafData[i + length(quantiles) + 1] <- sum(temp$accuracy) /
          length(temp$accuracy)

      }

      ## do the last one manually, too
      if(i == length(quantiles)){
        # get the data
        temp <- subset(data, data$rt > cdfs[i])
        # log the RT
        cafData[i + 1] <- mean(temp$rt)
        # log the accuracy
        cafData[(i + 1) + length(quantiles) + 1] <- sum(temp$accuracy) /
          length(temp$accuracy)
      }

    } #end of loop over quantiles

    # coerce the data into a final matrix for ease of use for user
    finalData <- matrix(0, nrow = 2, ncol = (length(cafData) / 2))
    row.names(finalData) <- c("rt", "accuracy")

    # populate the final data matrix
    finalData[1, 1:(length(cafData) / 2)] <- cafData[1:(length(cafData) / 2)]
    finalData[2, 1:(length(cafData) / 2)] <- cafData[((length(cafData) / 2)
                                                      + 1): length(cafData)]

    # return the means
    return(finalData)

  } #end of single-participant sub-function


  #multiple subjects-----------------------------------------------------------
  if(multipleParticipants == TRUE){

    # what are the unique participant numbers?
    subs <- unique(data$participant)

    # how many participants are there?
    nSubs <- length(subs)

    #empty matrix to store CAF data in
    cafData <- matrix(0, nrow  = ((length(quantiles) * 2) + 2), ncol = nSubs)


    # loop over all participants, get their CAFs, and store in cafData matrix
    for(j in 1:nSubs){

      # get the current subject's data
      subData <- subset(data, data$participant == subs[j])

      # get the current subject's CDF criteria
      subCDFs <- quantile(subData$rt, quantiles)


      # calculate mean RT and proportion error for each bin----------------------
      for(i in 1:length(quantiles)){

        ## do the first one manually
        if(i == 1){
          # get the data
          temp <- subset(subData, subData$rt < subCDFs[i])
          # log the RT
          cafData[i, j] <- mean(temp$rt)
          # log the accuracy
          cafData[i + length(quantiles) + 1, j] <- sum(temp$accuracy) /
            length(temp$accuracy)
        }

        ## do the rest of the slots automatically
        if(i > 1 & i <= length(quantiles)){

          # get the data
          temp <- subset(subData, subData$rt > subCDFs[i - 1] & subData$rt <
                           subCDFs[i])
          # log the RT
          cafData[i, j] <- mean(temp$rt)
          # log the accuracy
          cafData[i + length(quantiles) + 1, j] <- sum(temp$accuracy) /
            length(temp$accuracy)

        }

        ## do the last one manually, too
        if(i == length(quantiles)){
          # get the data
          temp <- subset(subData, subData$rt > subCDFs[i])
          # log the RT
          cafData[i + 1, j] <- mean(temp$rt)
          # log the accuracy
          cafData[(i + 1) + length(quantiles) + 1, j] <- sum(temp$accuracy) /
            length(temp$accuracy)
        }

      } # end of loop over quantiles


    } # end of loop over subjects

    # find the mean values
    cafData <- apply(cafData, 1, mean)

    # coerce the data into a final matrix for ease of use for user
    finalData <- matrix(0, nrow = 2, ncol = (length(cafData) / 2))
    row.names(finalData) <- c("rt", "accuracy")

    # populate the final data matrix
    finalData[1, 1:(length(cafData) / 2)] <- cafData[1:(length(cafData) / 2)]
    finalData[2, 1:(length(cafData) / 2)] <- cafData[((length(cafData) / 2)
                                                      + 1): length(cafData)]

    # return the means
    return(finalData)

  } # end of multiple subjects loop


} # end of function
#------------------------------------------------------------------------------
