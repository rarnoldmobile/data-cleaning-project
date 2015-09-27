Data Cleaning Project
=====================

Summary
-------
Data Cleaning Course Project - Wearable computing data.
The purpose is to take data gathered from Samsung Galaxy S smartphones, and put it through a data cleaning procedure.

The raw data itself can represent many various activity states, and includes a wide range of attributes for analysis.  The output data, in it's tidy form, includes only variables dealing wiht the Mean or Standard Deviation, averaged and grouped by Activity Name and Subject ID.

Please see the CodeBook.md file for further information about the data.

Source Data
-----------
Information about the original project and data collection method can be found here:
[UCI Link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The raw data can be downloaded from here:
[Raw Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


How-To
------
* Download the original zip from the above "raw data" link.  Unzip it and note where the directory is
* Run the "run_analysis.R" script.  You will be prompted for the above directory location
* Enter the directory location, and hit enter.
* The analysis will run, once complete an "output" directory, containing an "output.txt" file will be present with the final tidy data

Variables
---------
The system includes a few variables for tweaking and adjustment if necessary.
These are located at the top of the "run_analysis.R" file
```
columnKeepString <- "subjectID|activityID|activityName|*.mean.*|*.std.*|*Mean.*"
columnSummaryString <- "*.mean.*|*.std.*|*Mean.*"
outputDir <- "out"
outputFile <- "output.txt"
```

* columnKeepString contains a list of columns that will be kept from the raw data.  If you wish to keep additional columns, some wildcard expression separated by pipe ("|") will be needed in this string.
* columSummaryString contains a list of columns that will be averaged and output on the final dataset
* outputDir is the output directory that will contain our final tidy data file
* outputFile is the filename that we will write the table to


Processes
---------
The system will run 4 separate processes, representing various states of the analysis.  If you were to run the file manually, you have the option of just re-running certain steps throughout the lifecycle.
```
importReferenceData()
importRawData()
updateActivityData()
createSummaryData()
```

* importReferenceData runs the import for all reference level information (i.e. Activity Names, subject ID's, etc)
* importRawData will import the large data segment (10299 observations of 561 variables) and filter out any un-needed columns
* updateActivityData will update the activity ID's in the raw dataset to include full activity name
* createSummaryData will create our final tidy dataset and perform all of the aggregations specified