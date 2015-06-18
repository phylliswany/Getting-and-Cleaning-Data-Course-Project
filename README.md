run_analysis.R is used to clean the data collected from the accelerometers from the Samsung Galaxy S smartphone, which can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .  
  

The following code is used to download the data and unzip them.
```{r}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(fileurl, "dataset.zip", method="curl")  
unzip("dataset.zip")
```

The following code is used to load the training data set and testing data set with each includes the subject label, activity label and the accelerometer data.
```{r}
datatrain <- read.table("UCI HAR Dataset/train/X_train.txt")  
activitytrain <- read.table("UCI HAR Dataset/train/y_train.txt")  
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")  
datatest <- read.table("UCI HAR Dataset/test/X_test.txt")  
activitytest <- read.table("UCI HAR Dataset/test/y_test.txt")  
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
```

The following code is used to appending the testing data set to the training data set.
```{r}
dataall <- rbind(datatrain, datatest)  
activityall <- rbind(activitytrain, activitytest)  
subjectall <- rbind(subjecttrain, subjecttest)  
```

The following code is used to extracts only the measurements on the mean and standard deviation for each measurement and rename the column of the data table.
```{r}
subjectall <- rename(subjectall, subject=V1)  
activitylist <- read.table("UCI HAR Dataset/activity_labels.txt")  
activitystring <- activityall  
for (i in 1:length(activitylist$V1)){  
  index <- (activityall$V1 == activitylist$V1[i])  
  activitystring$V1[index] <- as.character(activitylist$V2[i])  
}  
activitystring <- rename(activitystring, activity=V1)  
featurelist <- read.table("UCI HAR Dataset/features.txt")  
index <- c(grep("mean()", featurelist$V2, fixed=TRUE), grep("std()", featurelist$V2, fixed=TRUE))  
dataselected <- dataall[,index]   
colnames(dataselected) <- featurelist$V2[index]  
```

The following code is used to combine the data table of the subject label, activity label and accelerometer data into a single data table.
```{r}
ActivityDataSet <- cbind(subjectall, activitystring, dataselected)  
```

The following code is used to calculate the average of each variable for each activity and each subject and save the data table into a file.
```{r}
ActivityMean <- ActivityDataSet %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(ActivityMean, "ActivityMean.txt", row.names=FALSE)
```

