# Codebook

You can read the full description of the data set this analysis is based [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data set itself also contains important information that will be alluded to:
[link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

This analysis firstly takes names from the files that describe the base dataset and uses them to generate factors and column names, as follows:

* activity_labels.txt - This file is used to give a human-readable name to the column "activity" in the data frame.
* features.txt - This file is used to name the many different variables (columns) available from the devices' accelerometers.

Then we take variables from several different files (in two different folders, relating to the "test" and the "train" datasets) and paste them together into a single data frame. Each of these files contain one observation per line, like so:

* subject_test.txt and subject_train.txt - These are the subject "identifiers", they identify each test participant
* y_test.txt and y_train.txt - These contain the activity the subject was doing during this observation (a numerical identifier that is converted using activity_labels.txt, as described above)
* X_test.txt and X_train.txt - These contain the actual accelerometer data as described in features.txt and features_info.txt

### Analysis Execution

The script first defines the initial folder and file "sub-name" to utilize in the analysis, as mentioned there are two categories of datasets to merge together.  

Then it calls the function makeDataFrame, which reads each relevant file in said folder and generates the data frame itself for that folder:

From the "subject_" file it takes the subjects' identifiers, from the "y_" file it takes the activities said subjects were executing during the observations (transforming them into human-readable file with the function replaceActivity) and, finally, from the "X_" file, it takes the accelerometer data.

It's important to note that from the "X_" file, only the measurements pertaining to the mean and standard deviation of each measurement are kept, as the Course Project demands. The rest are discarded. This is done by naming the columns using the "features.txt" file and utilizing only the columns that contain the strings "mean" or "std" in their name, the codebook of the original study was used to determine this.

The same process is done on the other folder, and the resulting data frames (training and test sets) are concatenated into a single data frame.

After this, the "activity" column in the data frame is transformed into a factor, to facilitate the splitting of the data.

Finally, the data is first split by subject, then by activity, this is done to calculate the average of each measurement for each subject/activity pair. The resulting data frame is then written to the file dataAvgs.txt.  
