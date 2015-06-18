library(dplyr)

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, "dataset.zip", method="curl") 
unzip("dataset.zip")

datatrain <- read.table("UCI HAR Dataset/train/X_train.txt")
activitytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
datatest <- read.table("UCI HAR Dataset/test/X_test.txt")
activitytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
dataall <- rbind(datatrain, datatest)
activityall <- rbind(activitytrain, activitytest)
subjectall <- rbind(subjecttrain, subjecttest)

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

ActivityDataSet <- cbind(subjectall, activitystring, dataselected)

ActivityMean <- ActivityDataSet %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(ActivityMean, "ActivityMean.txt", row.names=FALSE)