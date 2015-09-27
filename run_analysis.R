library("data.table")
library(plyr)
library(dplyr)

# Constants and variables needed for the program
# This is a list of conditions that will keep attributes from our total starting count of 561
# For instance, the "Standard Deviation appears as .std. somewhere in the column name
# Including *.std.* in this listing, will cause that column to stay in the dataset
# columnSummaryString is a similar concept 
# - but it will be our list of columns we need to summarize into our final tidy data

columnKeepString <- "subjectID|activityID|activityName|*.mean.*|*.std.*|*Mean.*"
columnSummaryString <- "*.mean.*|*.std.*|*Mean.*"
outputDir <- "out"
outputFile <- "output.txt"

# Prompt for directory that will contain all of our datasets
workingDirectory <- readline("Please input the directory of the untidy data (ex: ./documents/UCI_HAR_Dataset/): ")
setwd(workingDirectory)

#Import reference files for all column identifiers
importReferenceData <- function() {
    # Encapsulating this as a function to better segregate it from the rest of the code
    # Will make repeated calls and testing out specific portions easier as well if you need to re-import the data
    
    featureList <<- read.table("features.txt", header=FALSE, sep=" ", col.names = c("featureID", "featureName"))
    activityList <<- read.table("activity_labels.txt", header=FALSE, sep=" ", col.names = c("activityID", "activityName"))
    
    #Only push the labels and subject data into local scope, then combine and push back to parent
    trainingLabels <- read.table("train/y_train.txt", header=FALSE, sep=" ", col.names = c("activityID"))
    trainingSubjectData <- read.table("train/subject_train.txt", header=FALSE, sep=" ", col.names = c("subjectID"))
    testLabels <- read.table("test/y_test.txt", header=FALSE, sep=" ", col.names = c("activityID"))
    testSubjectData <- read.table("test/subject_test.txt", header=FALSE, sep=" ", col.names = c("subjectID"))
    
    dataList <- list(testLabels, trainingLabels)
    labelData <<- rbindlist(dataList)
    
    dataList <- list(testSubjectData, trainingSubjectData)
    subjectData <<- rbindlist(dataList)
}

#Import raw data
importRawData <- function() {
  
    # Raw data import - apply the featureList name vector to the data to cleanly name all columns
    trainingRawData <- read.table("train/X_train.txt", header=FALSE, col.names = featureList$featureName)
    testRawData <- read.table("test/X_test.txt", header=FALSE, col.names = featureList$featureName)
    
    # Append the final two datasets together
    # rbindlist was the fastest implementation
    dataList <- list(testRawData, trainingRawData)
    rawData <- rbindlist(dataList)
    
    # Append the appropriate columns onto the raw data and push back to parent environment
    rawData$subjectID <- subjectData$subjectID
    rawData$activityID <- labelData$activityID
    
    # Filter the columns
    rawData <<- rawData[, grep(columnKeepString, colnames(rawData)), with=FALSE]
}


# Update the activity label on each row, with the actual activity performed
# Pulling from the activityList reference data
updateActivityData <- function() {
  rawData <<- merge(x = rawData, y = activityList, by = c("activityID"))
}

# create the final tidy dataset
createSummaryData <- function() {
  summaryData <- data.table(activityName = factor(), subjectID = integer())
  
  # loop through all columns in the dataset
  for (i in rawData[, grep(columnSummaryString, colnames(rawData))]) {

    # Retrieve the name of the column
    tempName <- names(rawData)[i]
    
    #Calculate the mean of the variable and label it appropriately
    testOutput <- rawData[,mean(get(tempName)),by=c("activityName", "subjectID")]
    setnames(testOutput, "V1", paste("Mean", tempName, sep="."))
    
    #Merge back into the summary Data
    summaryData <- merge.data.frame(summaryData, testOutput, by.x=c("activityName", "subjectID"), by.y=c("activityName", "subjectID"), all=TRUE)
  }
  
  summaryData <<- summaryData
}


# Call Through our various processes
# At any point if something needs to be adjusted, you can re-ran that individual function
importReferenceData()
importRawData()
updateActivityData()
createSummaryData()

# Write final output
if (!file.exists(outputDir)) {
  dir.create(outputDir)
}

write.table(summaryData, row.names = FALSE, file = paste(outputDir, outputFile, sep="/"))

