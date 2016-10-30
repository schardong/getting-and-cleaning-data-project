source("pre_run_reqs.R")

data.path <- file.path(".", "data")
my.wd <- getwd()
dir.create(data.path, showWarnings = FALSE)
setwd(data.path)

if (!file.exists('dataset.zip')) {
    download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                  destfile = "dataset.zip")
    unzip(zipfile = "dataset.zip")
}

train.dataset.path <- file.path("UCI HAR Dataset", "train")
test.dataset.path <- file.path("UCI HAR Dataset", "test")

train.set.in <- readLines(file.path(train.dataset.path, "X_train.txt"))
train.set <- vapply(X = train.set.in,
                    FUN = function(X)
                        as.numeric(unlist(strsplit(X, split = "[ ]+"))),
                    FUN.VALUE = numeric(562))

test.set.in <- readLines(file.path(test.dataset.path, "X_test.txt"))
test.set <- vapply(X = test.set.in,
                   FUN = function(X)
                       as.numeric(unlist(strsplit(X, split = "[ ]+"))),
                   FUN.VALUE = numeric(562))


setwd(my.wd)
file.remove(data.path)

## Tasks:
##   1. Merges the training and the test sets to create one data set.
##   2. Extracts only the measurements on the mean and standard deviation for each measurement.
##   3. Uses descriptive activity names to name the activities in the data set
##   4. Appropriately labels the data set with descriptive variable names.
##   5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
