library(dplyr)

#Read Training Data
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
Y_Train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
X_Train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)


#Read Test Data

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
Y_Test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
X_Test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)


#Part 1 - MERGE DATA SET

X_Merge <- rbind(X_Train,X_Test)
Y_Merge <- rbind(Y_Train,Y_Test)



Merged_data <- cbind(Sub_Merge,Y_Merge,X_Merge)
#Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

dataFeaturesNames <- read.table( "UCI HAR Dataset/features.txt",header=FALSE)
names(X_Merge) <- dataFeaturesNames$V2

extract_measures <- grep("mean|std",dataFeaturesNames$V2,value = TRUE)


#Part 3 - Uses descriptive activity names to name the activities in the data set.

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)

Y_Merge$V1 <- factor(Y_Merge$V1, labels = activityLabels[,2])



#Part 4 - Appropriately labels the data set with descriptive variable names
#At first we will change the name of columns
names(X_Merge) <- dataFeaturesNames$V2
Merged_data <- X_Merge
 names(Merged_data)<-gsub("^t", "time", names(Merged_data))
 names(Merged_data)<-gsub("^f", "frequency", names(Merged_data))
 names(Merged_data)<-gsub("Acc", "Accelerometer", names(Merged_data))
 names(Merged_data)<-gsub("Gyro", "Gyroscope", names(Merged_data))
 names(Merged_data)<-gsub("Mag", "Magnitude", names(Merged_data))
 names(Merged_data)<-gsub("BodyBody", "Body", names(Merged_data))
 
 
#Binding the other two data frames. 
 Merged_data1 <- cbind(Merged_data,Sub_Merge,Y_Merge)

 
 #Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 #Changing the names of Columns
 names(Merged_data1)[80] <- "Subject"
 names(Merged_data1)[81] <- "Activity"
 
 
 tidyData <- aggregate(. ~Subject + Activity, Merged_data1, mean)
 
 write.table(tidyData, "tidyData.txt")

