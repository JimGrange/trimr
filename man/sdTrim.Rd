% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sdTrim.R
\name{sdTrim}
\alias{sdTrim}
\title{RT trimming with standard deviation criterion}
\usage{
sdTrim(
  data,
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
  digits = 3
)
}
\arguments{
\item{data}{A data frame with columns containing: participant identification
number ('pptVar'); condition identification, if applicable ('condVar');
response time data ('rtVar'); and accuracy ('accVar'). The RT can be in
seconds (e.g., 0.654) or milliseconds (e.g., 654). Typically, "condition"
will consist of strings. Accuracy must be coded as 1 for correct and 0 for
error responses.}

\item{minRT}{The lower criteria for acceptable response time. Must be in
the same form as rt column in data frame (e.g., in seconds OR milliseconds).
All RTs below this value are removed before proceeding with SD trimming.}

\item{sd}{The upper criteria for standard deviation cut-off.}

\item{pptVar}{The quoted name of the column in the data that identifies
participants.}

\item{condVar}{The quoted name of the column in the data that includes the
conditions.}

\item{rtVar}{The quoted name of the column in the data containing reaction
times.}

\item{accVar}{The quoted name of the column in the data containing accuracy,
coded as 0 or 1 for incorrect and correct trial, respectively.}

\item{perCondition}{Set to TRUE if the user wishes the trimming to occur per
condition of the experimental design.}

\item{perParticipant}{Set to TRUE if the user wishes the trimming to occur
per participant.}

\item{omitErrors}{If set to TRUE, error trials will be removed before
conducting trimming procedure. Final data returned will not be influenced
by errors in this case.}

\item{returnType}{Request nature of returned data. "raw" returns trial-
level data excluding trimmed data; "mean" returns mean response times per
participant for each experimental condition identified; "median" returns
median response times per participant for each experimental condition
identified.}

\item{digits}{How many decimal places to round to after trimming?}
}
\description{
\code{sdTrim} takes a data frame of RT data and returns trimmed rt
data that fall below a set set criterion (based on standard deviations
above a particular mean). The criterion can be based on the mean of the
whole set of data, based on the mean per experimental condition, based on
the mean per participant, or based on the mean of each participant in each
experimental condition.
}
\details{
By passing a data frame containing raw response time data, together with
trimming criteria, the function will return trimmed data, either in the form
of trial-level data or in the form of means/medians for each subject &
condition.
}
\examples{
# load the example data that ships with trimr
data(exampleData)

# perform the trimming with SD trimming per condition, returning mean RT
trimmedData <- sdTrim(data = exampleData, minRT = 150, sd = 2.5,
perCondition = TRUE, perParticipant = FALSE, returnType = "mean")

}
