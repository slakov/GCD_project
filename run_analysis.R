
# Merge the training and the test sets to create one data set.

features <- read.table("./UCI HAR Dataset/features.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X <- rbind(X_test, X_train)

# Extract only the measurements on the mean and standard deviation for each measurement. 
interestingFeatures <- features[grep("(mean|std)\\(", features[,2]),]
mean_and_std <- X[,interestingFeatures[,1]]

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
y <- rbind(y_test, y_train)

labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
for (i in 1:nrow(labels)) {
  code <- as.numeric(labels[i, 1])
  name <- as.character(labels[i, 2])
  y[y$activity == code, ] <- name
}

X_with_labels <- cbind(y, X)
mean_and_std_with_labels <- cbind(y, mean_and_std)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subject_test, subject_train)
averages <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)

write.table(averages, file='tidy_run.txt', sep="\t", row.names=FALSE)