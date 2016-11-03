source("pre_run_reqs.R")

## Setting the correct dataset paths.
data.path <- file.path(".", "data")
dataset.file <- file.path(data.path, "dataset.zip")
root.dataset.path <- file.path(data.path, "UCI HAR Dataset")
train.dataset.path <- file.path(root.dataset.path, "train")
test.dataset.path <- file.path(root.dataset.path, "test")

dir.create(data.path, showWarnings = FALSE)
if (!file.exists(dataset.file)) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  destfile = dataset.file)
    unzip(zipfile = dataset.file,
          exdir = data.path)
}

## Reading the dataset's features.
## We replace the minus signs for underscores in order to be able to select the
## columns by name using dplyr later.
features <- read.table(file.path(root.dataset.path, "features.txt"),
                       col.names = c("Label", "Name"),
                       colClasses = "character")
features <- features %>% mutate(Label = as.integer(Label),
                                Name = gsub("-", "_", Name))

## Reading the activity attributed to each label.
activity.labels <- read.table(file.path(root.dataset.path, "activity_labels.txt"),
                              col.names = c("Label", "Activity"),
                              colClasses = "character")
activity.labels <- activity.labels %>% mutate(Label = as.integer(Label))

## Reading the training dataset, it's activity labels and subject labels.
train.set.in <- readLines(file.path(train.dataset.path, "X_train.txt"))
train.set <- as.data.frame(t(vapply(X = train.set.in,
                                    FUN = function(X)
                                        as.numeric(unlist(strsplit(X, split = "[ ]+"))),
                                    FUN.VALUE = numeric(562))))
train.set$V1 <- NULL
train.set.activities <- as.integer(readLines(file.path(train.dataset.path, "y_train.txt")))
train.set.subjects <- as.integer(readLines(file.path(train.dataset.path, "subject_train.txt")))
train.set <- train.set %>%
  mutate(Activities = train.set.activities, Subject = train.set.subjects)
rm(train.set.in, train.set.activities, train.set.subjects)

## Reading the test dataset and it's labels.
test.set.in <- readLines(file.path(test.dataset.path, "X_test.txt"))
test.set <- as.data.frame(t(vapply(X = test.set.in,
                                   FUN = function(X)
                                       as.numeric(unlist(strsplit(X, split = "[ ]+"))),
                                   FUN.VALUE = numeric(562))))
test.set$V1 <- NULL
test.set.activities <- as.integer(readLines(file.path(test.dataset.path, "y_test.txt")))
test.set.subjects <- as.integer(readLines(file.path(test.dataset.path, "subject_test.txt")))
test.set <- test.set %>%
  mutate(Activities = test.set.activities, Subject = test.set.subjects)
rm(test.set.in, test.set.activities, test.set.subjects)

## Merging the training and test sets
merged.set <- rbind(train.set, test.set)
names(merged.set)[1:(ncol(merged.set)-2)] <- features$Name

## Getting the mean and std columns of the dataset.
## Dirty trick to get only the *mean() named columns and no the *meanFreq() ones.
## We first search for all columns with a "mean" keyword in them and then, in
## these resulting columns, we search for the ones with the "Freq" keyword.
## After their indices are returned, we remove them from the subset of "mean"-named
## columns.
mean.cols <- grep("mean", names(merged.set))
freq.cols <- grep("Freq", names(merged.set)[mean.cols])
mean.cols <- mean.cols[-freq.cols]
## Getting the std columns of the dataset.
std.cols <- grep("std", names(merged.set))
## Merging the mean and std column indices.
selected.cols <- names(merged.set)[c(mean.cols, std.cols)]
selected.cols <- c("Subject", "Activities", selected.cols)

merged.set <- merged.set[, selected.cols]

## Reference:
##  https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/
## Tasks:
##   1. Merges the training and the test sets to create one data set. (done)
##   2. Extracts only the measurements on the mean and standard deviation for each measurement. (done)
##   3. Uses descriptive activity names to name the activities in the data set (TODO)
##     3.a. Replace the numbers in the Activities column for the corresponding labels.
##     3.b. Use the merged.set Activities column as index to the activity.labels Activities column.
##       and replace the merged.set column using those values.
##   4. Appropriately labels the data set with descriptive variable names. (done)
##   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. (TODO)
