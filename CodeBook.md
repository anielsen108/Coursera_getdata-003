Samsung Accelerometer Data Code Book
========================================================

This code book describes the variables, the data, and transformations performed to clean up the data 

Raw Data
--------
[Original Data Set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

[Original Data Set Description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Transformation of Raw Data into Tidy Data
-----------------------------------------
The "run_analysis.R" script prepares Samsung Human Activity Recognition for further analysis.  It transforms the raw data into a data set consisting of mean and standard deviation measures, summarized by Subject and Activity Name.

To run it, place the script and the Samsung data folder "UCI HAR Dataset" in the working directory.

The resulting output file is a csv file "UciHarTidy.txt"

The basic outline of the script is as follows:

1. Read and Merge training and test measures to create one data set.
2. Read and Merge training and test subject lists to create one data set.
3. Read and Merge training and test activity lists to create one data set.
4. Transform the activity data set of activity ids into activity names. 
5. Combine Subject List, Activity List, and Measures into a single data set
6. Remove columns other than measurements of the mean and standard deviation.
7. Label measurement columns with measurement names
8. Summarize data with mean, by Subject and Activity Name.
9. Write tidy data set to csv file "UciHarTidy.csv"

Thse script will install the "reshape2" package if it is not installed.

Key Columns:
------------
subject - Anonymous Subject ID [1..30]  
activityName -- One of six activities: walking, walkingupstairs, walkingdownstairs, sitting, standing, laying  

Measure Columns:
------------
All measure labels are in this format:  
{Domain}{Motion Component}{Extra Information}{Summary}{Axis}  

{Domain}: t for Time, f for Frequency  
{Motion Component}: Body or Gravity  
{Sensor}: Acc for accelerometer, Gyro forgyroscope  
{Extra Information}: Optional additional Information  
{Summary}: mean or std (standard deviation)  
{Axis}: X, Y, or Z  

Measure Example 
------------
fBodyAccJerkmeanZ implies  

Domain = f (frequency)  
Motion Component = Body  
Sensor = Acc (accelerometer)  
Extra Information = Jerk  
Summary = mean  
Axis = Z  





