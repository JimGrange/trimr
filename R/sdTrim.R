#------------------------------------------------------------------------------
#' RT trimming with standard deviation criterion
#'
#' \code{sdTrim} takes a data frame of RT data and returns trimmed rt
#' data that fall below a set set criterion (based on standard deviations
#' above a particular mean). The criterion can be based on the mean of the
#' whole set of data, based on the mean per experimental condition, based on
#' the mean per participant, or based on the mean of each participant in each
#' experimental condition.
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
#' All RTs below this value are removed before proceeding with SD trimming.
#' @param sd The upper criteria for standard deviation cut-off.
#' @param pptVar The quoted name of the column in the data that identifies
#' participants.
#' @param condVar The quoted name of the column in the data that includes the
#' conditions.
#' @param rtVar The quoted name of the column in the data containing reaction
#' times.
#' @param accVar The quoted name of the column in the data containing accuracy,
#' coded as 0 or 1 for incorrect and correct trial, respectively.
#' @param perCondition Set to TRUE if the user wishes the trimming to occur per
#' condition of the experimental design.
#' @param perParticipant Set to TRUE if the user wishes the trimming to occur
#' per participant.
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
#' # perform the trimming with SD trimming per condition, returning mean RT
#' trimmedData <- sdTrim(data = exampleData, minRT = 150, sd = 2.5,
#' perCondition = TRUE, perParticipant = FALSE, returnType = "mean")
#'
#' @importFrom stats median sd
#'
#' @export
sdTrim <- function(data,
                   minRT,
                   sd,
                   pptVar = "participant",
                   condVar = "condition",
                   rtVar = "rt",
                   accVar = "accuracy",
                   perCondition = TRUE,
                   perParticipant = TRUE,
                   omitErrors = TRUE,
                   returnType = "mean",
                   digits = 3) {

  ###-------------
  if(perCondition == FALSE & perParticipant == FALSE){
    # change the variable name for sd (as this is an R function)
    stDev <- sd

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

    # what is the mean & SD of the whole group's data?
    meanRT <- mean(trimmedData[[rtVar]])
    sdRT <- sd(trimmedData[[rtVar]])

    # what is the cut-off value?
    cutoff <- meanRT + (stDev * sdRT)

    # remove these rts
    trimmedData <- trimmedData[trimmedData[[rtVar]] < cutoff, ]


    # if the user asked for trial-level data, return immediately to user
    if(returnType == "raw"){
      return(trimmedData)
    }

    # if the user has asked for means, then split the data into separate
    # conditions, and display the means per condition.
    if(returnType == "mean"){

      # ready the final data set
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

          # get that participant's data
          participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

          # calculate & store their mean response time
          finalData[i, j] <- round(mean(participantData[[rtVar]]),
                                   digits = digits)

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

          # get that participant's data
          participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

          # calculate & store their mean response time
          finalData[i, j] <- round(median(participantData[[rtVar]]),
                                   digits = digits)

          # update participant counter
          i <- i + 1
        }

        # update nCondition counter
        j <- j + 1

      } # end of condition loop

      return(finalData)

    }

  } # end of perCell == FALSE & perParticipant == FALSE


  ###-------------
  if(perCondition == TRUE & perParticipant == FALSE){

    # change the variable name for sd (as this is an R function)
    stDev <- sd

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

    ### do "raw"
    if(returnType == "raw"){

      # initialise variable to keep trimmed data in
      finalData <- NULL

      # loop over each condition
      for(cond in conditionList){

        # get the data, & find cutoff
        curData <- trimmedData[trimmedData[[condVar]] == cond, ]
        curMean <- mean(curData[[rtVar]])
        curSD <- sd(curData[[rtVar]])
        curCutoff <- curMean + (stDev * curSD)

        # trim the data
        curData <- curData[curData[[rtVar]] < curCutoff, ]

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
        curData <- trimmedData[trimmedData[[condVar]] == cond, ]
        curMean <- mean(curData[[rtVar]])
        curSD <- sd(curData[[rtVar]])
        curCutoff <- curMean + (stDev * curSD)

        # trim the data
        curData <- curData[curData[[rtVar]] < curCutoff, ]

        # bind the data
        tempData <- rbind(tempData, curData)
      }

      # change variable names
      trimmedData <- tempData
      tempData <- NULL

      ## now loop over each subject and calculate their average
      # ready the final data set
      finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                        ncol = length(conditionList)))

      # give the columns the condition names
      colnames(finalData) <- conditionList

      # add the participant column
      finalData <- cbind(participant, finalData)


      # loop over conditions & subjects and calculate their average

      # to index over conditions. It starts at 2 because this is the first
      # column in the data frame containing condition information
      j <- 2

      for(curCondition in conditionList){

        # get the current condition's data
        tempData <- trimmedData[trimmedData[[condVar]] == curCondition, ]

        #now loop over all participants
        i <- 1

        for(currParticipant in participant){

          # get that participant's data
          participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

          # calculate & store their mean response time
          finalData[i, j] <- round(mean(participantData[[rtVar]]),
                                   digits = digits)

          # update participant counter
          i <- i + 1
        }

        # update nCondition counter
        j <- j + 1
      }

      return(finalData)
    }

  } # end of perCell == TRUE & perParticipant == FALSE


  ###-------------
  if(perCondition == FALSE & perParticipant == TRUE){

    # change the variable name for sd (as this is an R function)
    stDev <- sd

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


    ### do "raw"
    if(returnType == "raw"){

      # initialise variable to keep trimmed data in
      finalData <- NULL

      # loop over each subject
      for(currSub in participant){

        # get the current subject's data
        curData <- trimmedData[trimmedData[[pptVar]] == currSub, ]

        # find their mean, sd, & cutoff
        curMean <- mean(curData[[rtVar]])
        curSD <- sd(curData[[rtVar]])
        curCutoff <- curMean + (stDev * curSD)

        # trim the data
        curData <- curData[curData[[rtVar]] < curCutoff, ]

        # bind the data
        finalData <- rbind(finalData, curData)
      }

      return(finalData)
    }


    ### do "mean"
    if(returnType == "mean"){

      # initialise variable to keep trimmed data in
      tempData <- NULL

      # loop over each subject
      for(currSub in participant){

        # get the current subject's data
        curData <- trimmedData[trimmedData[[pptVar]] == currSub, ]

        # find their mean, sd, & cutoff
        curMean <- mean(curData[[rtVar]])
        curSD <- sd(curData[[rtVar]])
        curCutoff <- curMean + (stDev * curSD)

        # trim the data
        curData <- curData[curData[[rtVar]] < curCutoff, ]

        # bind the data
        tempData <- rbind(tempData, curData)
      }

      # change variable names
      trimmedData <- tempData
      tempData <- NULL

      # ready the final data set
      finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                        ncol = length(conditionList)))

      # give the columns the condition names
      colnames(finalData) <- conditionList

      # add the participant column
      finalData <- cbind(participant, finalData)

      # convert to data frame
      finalData <- data.frame(finalData)

      # loop over conditions & subjects and calculate their average

      # to index over conditions. It starts at 2 because this is the first
      # column in the data frame containing condition information
      j <- 2

      for(curCondition in conditionList){

        # get the current condition's data
        tempData <- trimmedData[trimmedData[[condVar]] == curCondition, ]

        #now loop over all participants
        i <- 1

        for(currParticipant in participant){

          # get that participant's data
          participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

          # calculate & store their mean response time
          finalData[i, j] <- round(mean(participantData[[rtVar]]),
                                   digits = digits)

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

      # initialise variable to keep trimmed data in
      tempData <- NULL

      # loop over each subject
      for(currSub in participant){

        # get the current subject's data
        curData <- trimmedData[trimmedData[[pptVar]] == currSub, ]

        # find their mean, sd, & cutoff
        curMean <- mean(curData[[rtVar]])
        curSD <- sd(curData[[rtVar]])
        curCutoff <- curMean + (stDev * curSD)

        # trim the data
        curData <- curData[curData[[rtVar]] < curCutoff, ]

        # bind the data
        tempData <- rbind(tempData, curData)
      }

      # change variable names
      trimmedData <- tempData
      tempData <- NULL

      # ready the final data set
      finalData <- as.data.frame(matrix(0, nrow = length(participant),
                                        ncol = length(conditionList)))

      # give the columns the condition names
      colnames(finalData) <- conditionList

      # add the participant column
      finalData <- cbind(participant, finalData)


      # loop over conditions & subjects and calculate their average

      # to index over conditions. It starts at 2 because this is the first
      # column in the data frame containing condition information
      j <- 2

      for(curCondition in conditionList){

        # get the current condition's data
        tempData <- trimmedData[trimmedData[[condVar]] == curCondition, ]

        #now loop over all participants
        i <- 1

        for(currParticipant in participant){

          # get that participant's data
          participantData <- tempData[tempData[[pptVar]] == currParticipant, ]

          # calculate & store their mean response time
          finalData[i, j] <- round(median(participantData[[rtVar]]),
                                   digits = digits)

          # update participant counter
          i <- i + 1
        }

        # update nCondition counter
        j <- j + 1
      }

      return(finalData)

    }


  } # end of perCell == FALSE & perParticipant == TRUE



  ###-------------
  if(perCondition == TRUE & perParticipant == TRUE){
    # change the variable name for sd (as this is an R function)
    stDev <- sd

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

    ### do "raw"
    if(returnType == "raw"){

      # initialise variable to keep trimmed data in
      finalData <- NULL

      # loop over all participants
      for(currSub in participant){

        # loop over all conditions
        for(currCond in conditionList){

          # get the relevant data
          tempData <- trimmedData[trimmedData[[condVar]] == currCond &
                                    trimmedData[[pptVar]] == currSub, ]

          # find the cutoff
          curMean <- mean(tempData[[rtVar]])
          curSD <- sd(tempData[[rtVar]])
          curCutoff <- curMean + (stDev * curSD)

          # perform the trim
          curData <- tempData[tempData[[rtVar]] < curCutoff, ]

          # store the data
          finalData <- rbind(finalData, curData)
        }
      }

      return(finalData)
    }



    ### do "mean"
    if(returnType == "mean"){

      # ready the final data set
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

          # find the cutoff
          curMean <- mean(tempData[[rtVar]])
          curSD <- sd(tempData[[rtVar]])
          curCutoff <- curMean + (stDev * curSD)

          # trim the data
          curData <- tempData[tempData[[rtVar]] < curCutoff, ]

          # find the average, and add to the data frame
          finalData[i, j] <- round(mean(curData[[rtVar]]),
                                   digits = digits)

          # update condition loop counter
          j <- j + 1
        }

        # update participant loop counter
        i <- i + 1
      }

      return(finalData)

    }


    ### do "median"
    if(returnType == "median"){

      # ready the final data set
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

          # find the cutoff
          curMean <- mean(tempData[[rtVar]])
          curSD <- sd(tempData[[rtVar]])
          curCutoff <- curMean + (stDev * curSD)

          # trim the data
          curData <- tempData[tempData[[rtVar]] < curCutoff, ]

          # find the average, and add to the data frame
          finalData[i, j] <- round(median(curData[[rtVar]]), digits = digits)

          # update condition loop counter
          j <- j + 1
        }

        # update participant loop counter
        i <- i + 1
      }

      return(finalData)
    }

  } # end of perCell == TRUE & perParticipant == TRUE

} # end of function
#------------------------------------------------------------------------------
