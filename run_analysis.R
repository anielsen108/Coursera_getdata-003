# Assumptions: 
#  The Samsung data folder "UCI HAR Dataset" is in the working directory.
# 
# Output: 
#  A tidy data set "UciHarTidy.csv"
#  consisting of mean and standard deviation measures,
#  summarized by Subject and Activity Name

# Read and Merge training and test measures to create one data set.
testMeasures <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                           header = FALSE, fill = FALSE, sep = "")
trainMeasures <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                            header = FALSE, fill = FALSE, sep = "")
combinedMeasures <- rbind(testMeasures, trainMeasures)
rm(testMeasures)
rm(trainMeasures)

# Read and Merge training and test subject lists to create one data set.
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                          header = FALSE, fill = FALSE, sep = "")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                           header = FALSE, fill = FALSE, sep = "")
combinedSubject <- rbind(testSubject, trainSubject)
rm(testSubject)
rm(trainSubject)

# Read and Merge training and test activity lists to create one data set.
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                           header = FALSE, fill = FALSE, sep = "")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                            header = FALSE, fill = FALSE, sep = "")
combinedActivity <- rbind(testActivity, trainActivity)
rm(testActivity)
rm(trainActivity)
colnames(combinedActivity) <- c("activityId")

# Read in mapping of Activity ID to Activity Name 
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                             header = FALSE, fill = FALSE, sep = "")
activityLabels[,2] <- tolower(activityLabels[,2])
activityLabels[,2] <- gsub("_","",activityLabels[,2])
colnames(activityLabels) <- c("activityId","activityName")
rownames(activityLabels) <- activityLabels$activityId

# Transform the activity data set of activity ids into activity names. 
combinedActivityLabels <- merge(combinedActivity, activityLabels)

# Combine Subject List, Activity List, and Measures into a single data set
combinedData <- cbind(combinedSubject, combinedActivityLabels$activityName, combinedMeasures)
colnames(combinedData)[1] <- "subject"
colnames(combinedData)[2] <- "activityName"

# Read and clean up list of measurement labels
measureNames <- read.table("./UCI HAR Dataset/features.txt", 
                           header = FALSE, fill = FALSE, sep = "")
measureNames[,2] <- measureNames[,2]
measureNames[,2] <- gsub("-","",measureNames[,2])
measureNames[,2] <- gsub("\\(","",measureNames[,2])
measureNames[,2] <- gsub("\\)","",measureNames[,2])

# Remove columns other than measurements of the mean and standard deviation.
# Filter measurement names to match. 
# Label measurement columns with measurement names
measureNamesMeanStd <- measureNames[grepl("mean[^F]|std",measureNames[,2]),2]
combinedDataMeanStd <- combinedData[,grepl("mean[^F]|std",measureNames[,2])]
colnames(combinedDataMeanStd)[3:ncol(combinedDataMeanStd)] <- 
  measureNamesMeanStd
rm(activityLabels)
rm(combinedActivity)
rm(combinedActivityLabels)
rm(combinedData)
rm(combinedMeasures)
rm(combinedSubject)
rm(measureNames)
rm(measureNamesMeanStd)

# Summarize data with mean, by Subject and Activity Name.
summarizedData <- aggregate.data.frame(
  combinedDataMeanStd[3:ncol(combinedDataMeanStd)],
  by=list(subject = combinedDataMeanStd$subject, 
          activityName = combinedDataMeanStd$activityName),
  mean)

# Write tidy data set to csv file "UciHarTidy.csv"
write.csv(summarizedData,"UciHarTidy.txt", row.names = FALSE)
rm(combinedDataMeanStd)
rm(summarizedData)
