#Todo: replace Set with Measure
# Assumptions: The Samsung data folder "UCI HAR Dataset" is in the working directory
# Output: tidy data set "UciHarTidy.csv", which consists of mean and standard deviation measures,
#         summarized by Subject and Activity Name


# Read and Merge the training and the test measures to create one data set.
testMeasures <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, fill = FALSE, sep = "")
trainMeasures <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, fill = FALSE, sep = "")
combinedMeasures <- rbind(testMeasures, trainMeasures)
rm(testMeasures)
rm(trainMeasures)

# Read and Merge the training and the test subject lists to create one data set.
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, fill = FALSE, sep = "")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, fill = FALSE, sep = "")
combinedSubject <- rbind(testSubject, trainSubject)
rm(testSubject)
rm(trainSubject)

# Read and Merge the training and the test activity lists to create one data set.
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE, fill = FALSE, sep = "")
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE, fill = FALSE, sep = "")
combinedActivity <- rbind(testActivity, trainActivity)
colnames(combinedActivity) <- c("activityId")

# Read in Activity ID to Activity Name mapping
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("activityId","activityName")
rownames(activityLabels) <- activityLabels$activityId

# Label the activity data set with descriptive activity names. 
combinedActivityLabels <- merge(combinedActivity, activityLabels)
rm(testActivity)
rm(trainActivity)

# combine Subject List, Activity List, and Measures into a single data set
combinedData <- cbind(combinedSubject, combinedActivityLabels$activityName, combinedMeasures)
colnames(combinedData)[1] <- "subject"
colnames(combinedData)[2] <- "activityName"

# Read and clean up list of measurement labels ("features")
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, fill = FALSE, sep = "")
featuresMeanStd <- gsub("-","",featuresMeanStd)
featuresMeanStd <- gsub("\\(","",featuresMeanStd)
featuresMeanStd <- gsub("\\)","",featuresMeanStd)

# Remove columns other than measurements of the mean and standard deviation.
# Filter measurement label list to match. 
combinedDataMeanStd <- combinedData[,grepl("mean[^F]|std",features[,2])]
featuresMeanStd <- features[grepl("mean[^F]|std",features[,2]),2]

# Label measurement columns with measurement labels
colnames(combinedDataMeanStd)[3:ncol(combinedDataMeanStd)] <- featuresMeanStd

# Summarize data via mean, by Subject and Activity Name.
summarizedData <- aggregate.data.frame(combinedDataMeanStd[3:ncol(combinedDataMeanStd)],by=list(subject = combinedDataMeanStd$subject, activityName = combinedDataMeanStd$activityName),mean)

# Write tidy data set to csv file "UciHarTidy.csv"
rownames(summarizedData) <- NULL
write.csv(summarizedData,"UciHarTidy.csv")
