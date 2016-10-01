library(reshape2)

#load activity and features
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#extract data which have mean std only
f <- grep(".*mean.*|.*std.*",features[,2])
g <- features[f,2]
g <- gsub('-mean','Mean',g)
g <- gsub('-std','Std',g)
g <- gsub('[-()]','',g)

#load the train and test datasets
temp <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainX <- temp[f]
trainY <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainS <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainS,trainY,trainX)

temp <- read.table("./UCI HAR Dataset/test/X_test.txt")
testX <- temp[f]
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testS <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testS,testY,testX)

#merge and add labels
data <- rbind(train,test)
colnames(data) <- c("subject", "activity",g)

#convert activity and subjects into factors
data$activity <- factor(data$activity,levels = activityLabels[,1],labels=activityLabels[,2])
data$subject <- as.factor(data$subject)

#melt and dcast
data1 <- melt(data,id=c("subject","activity"))
data2 <- dcast(data1,subject +activity ~ variable, mean)

#write into "tidy.txt"
write.table(data2,"tidy.txt",row.names=FALSE,quote = FALSE)