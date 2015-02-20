library(plyr)

# Merge the training and test sets to create one data set

merge <- function(firstSet, secondSet) {
  f <- read.table(firstSet)
  s <- read.table(secondSet)
  rbind(f, s)
}
x_data <- merge("data/train/X_train.txt", "data/test/X_test.txt")
y_data <- merge("data/train/y_train.txt", "data/test/y_test.txt")
subject_data <- merge("data/train/subject_train.txt", "data/test/subject_test.txt")

# Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("data/features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

# Use descriptive activity names to name the activities in the data set
activities <- read.table("data/activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "tidy_data.txt", row.name=FALSE)
