## Getting and Cleaning Data, Course Project, 6/17/2014
## Tidy data preparation for Human Activity Recognition Using Smartphones Data Set
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Load data

## Import activity_labels.txt and features.txt to extract labels
temp <- read.table("activity_labels.txt", sep = "", stringsAsFactors = FALSE)
activityLabels <- temp$V2
temp <- read.table("features.txt", sep = "", stringsAsFactors = FALSE)
features <- temp$V2

## Import training data
Xtrain <- read.table("train/X_train.txt", sep = "")
names(Xtrain) <- features
ytrain <- read.table("train/y_train.txt", sep = "")
names(ytrain) <- "activity"
ytrain$activity <- as.factor(ytrain$activity)
levels(ytrain$activity) <- activityLabels
subjectTrain <- read.table("train/subject_train.txt", sep = "")
names(subjectTrain) <- "subject"
subjectTrain$subject <- as.factor(subjectTrain$subject)
train <- cbind(subjectTrain, ytrain, Xtrain)

## Import testing data
Xtest <- read.table("test/X_test.txt", sep = "")
names(Xtest) <- features
ytest <- read.table("test/y_test.txt", sep = "")
names(ytest) <- "activity"
ytest$activity <- as.factor(ytest$activity)
levels(ytest$activity) <- activityLabels
subjectTest <- read.table("test/subject_test.txt", sep = "")
names(subjectTest) <- "subject"
subjectTest$subject <- as.factor(subjectTest$subject)
test <- cbind(subjectTest, ytest, Xtest)

## Merge training and testing data sets
train$group <- "Train"
test$group <- "Test"
data <- rbind(train, test)
data$group <- as.factor(data$group)

## Extract measurements on the mean and standard deviation for each measurement
mean_std <- c("mean", "std")
data_mean_std <- data[, c("subject", "activity", grep(paste(mean_std, collapse = "|"), 
names(data), value = TRUE))]

## Write the tidy data set to file tidy_data.txt
write.table(data_mean_std, file = "../tidy_data.txt", quote = FALSE)

## Create a second, independent tidy data set with the average variable for each
## activity and each subject
## Aggregate data to have unique subject and activity combinations
data_body <- data[, 3:563]
by1 <- data[, 1]
by2 <- data[, 2]
aggdata <- aggregate(x = data_body, by = list(subject = by1, activity = by2), 
FUN = "mean")
aggdata <- aggdata[order(aggdata$subject, aggdata$activity),]

## Write the second tidy data set to file tidy_data2.txt
write.table(aggdata, file = "../tidy_data2.txt", quote = FALSE)
