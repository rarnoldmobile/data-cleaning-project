Getting and Cleaning Data
=========================




Data Source Information
-----------------------
[1]The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


URLs of note
------------
Information about the original project and data collection method can be found here:
[UCI Link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The raw data can be downloaded from here:
[Raw Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


File Listing
------------

The following files are found in the unzipped folder of your original dataset (downloaded from the link above)

* `features_info.txt`: Feature level information found on the X data sets
* `features.txt`: Listing of all feature names found on the X data sets
* `activity_labels.txt`: Lists all activity names and their corresponding labels
* `train/X_train.txt`: Full Training Data
* `train/y_train.txt`: Full Training Labels
* `test/X_test.txt`: Full Test Data
* `test/y_test.txt`: Full Test Labels
* `train/subject_train.txt`: Row level data identifying the subject id's to be attached to each row in the X training dataset
* `test/subject_train.txt`: Row level data identifying the subject id's to be attached to each row in the X testing dataset
* `out/output.txt`: Final tidy output data.  Only generated after running the R analysis script



Variables
---------
The following variables are found in the Raw data file prior to tidying.  View the "README.md" file for further information on including other variables in the tidy data.
*Note*: By default we are including the "additional vectors" section in our final averages

###Raw Data
* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

For each of the above variables, the following classifications were taken: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

###Tidy Data
The mean was taken for the following values in each of the Raw Data columns above:
* mean(): Mean value
* std(): Standard deviation
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency

In addition to that, the mean was taken for the following columns as well:  
* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

This data was grouped by activity name and subject id.


Transformation
--------------
* The test and training datasets were appended to each other
  * X_test.txt + X_train.txt
  * test/subject_test.txt + train/subject_train.txt
  * test/y_test.txt + train/y_train.txt
* The Activity Name was added to the compiled X dataset (x_test + x_train)
* The subject ID was added to the compiled X dataset
* Filters were applied to limit the attribute variables to only columns who matched:
  * *.mean.*
  * *.std.*
  * *Mean.*
  * subjectID
  * activityName
  * activityID
* All columns were averaged out to activityName and subjectID


Notes on program design
-----------------------
Each logical step of the design was carved into 4 separate functions.

This allowed for an easier method to debug the data, by running and adjusting one function repeatedly.  The rationale was that any eventual end user of the program could then choose to modify and tweak - and only re-run certain logical steps.

Variables at the top of the R file were used to help show some initial options at the very beginning as well.  Users can tweak/tune these options to their own environment and preferences.

Certain methods were chosen based on their performance time.  The biggest of which is the "rbindlist" call to allow for quickly appending datasets together.

There are other unoptimized methods in the file - chosen for clarity and readability in lieu of performance - the performance difference in these methods were negligible.  The biggest point where you can see this - is the process where each column is averaged out.


References
----------

[1] http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones