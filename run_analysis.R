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
## columns by name using dplyr later. We also replace the parenthesis in a
## subsequent call to gsub.
features <- read.table(file.path(root.dataset.path, "features.txt"),
                       col.names = c("Label", "Name"),
                       colClasses = "character")
features <- features %>%
  select(Name) %>%
  mutate(Name = gsub('[-,]', '_', Name)) %>%
  mutate(Name = gsub('[()]', '', Name))

## Reading the activity attributed to each label, removing the numeric label,
## capitalizing the first letter of each activity and replacing the underscores
## for spaces.
activity.labels <- read.table(file.path(root.dataset.path, "activity_labels.txt"),
                              col.names = c("Label", "Activity"),
                              colClasses = "character")
activity.labels <- activity.labels %>%
  select(Activity) %>%
  mutate(Activity = str_to_title(gsub('_', ' ', Activity)))

## Reading the training dataset, it's activity labels and subject labels.
train.set.in <- readLines(file.path(train.dataset.path, "X_train.txt"))
train.set <- as.data.frame(t(vapply(X = train.set.in,
                                    FUN = function(X)
                                        as.numeric(unlist(strsplit(X, split = "[ ]+"))),
                                    FUN.VALUE = numeric(562))))
train.set$V1 <- NULL
train.set.activities <- as.integer(readLines(file.path(train.dataset.path, "y_train.txt")))
train.set.subjects <- as.integer(readLines(file.path(train.dataset.path, "subject_train.txt")))
train.set <- mutate(train.set,
                    Activity = train.set.activities,
                    Subject = train.set.subjects)
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
test.set <- mutate(test.set,
                   Activity = test.set.activities,
                   Subject = test.set.subjects)
rm(test.set.in, test.set.activities, test.set.subjects)

## Merging the training and test sets and deleting them, since they are no longer
## needed.
merged.set <- rbind(train.set, test.set)
names(merged.set)[1:(ncol(merged.set)-2)] <- features$Name
rm(train.set, test.set)

## Getting the mean and std columns of the dataset.
## Dirty trick to get only the *mean() named columns and not the *meanFreq() ones.
## We first search for all columns with a "mean" keyword in them and then, in
## these resulting columns, we search for the ones with the "Freq" keyword.
## After their indices are returned, we remove them from the subset of "mean"-named
## columns.
mean.cols <- grep("mean", names(merged.set))
freq.cols <- grep("Freq", names(merged.set)[mean.cols])
mean.cols <- mean.cols[-freq.cols]
## Getting the std columns of the dataset.
std.cols <- grep("std", names(merged.set))
## Merging the mean and std column indices and adding the Subject and Activity
## columns to the set.
selected.cols <- names(merged.set)[c(mean.cols, std.cols)]
selected.cols <- c("Subject", "Activity", selected.cols)
merged.set <- merged.set[, selected.cols]

## Replacing the activity labels by nice names.
merged.set <- mutate(merged.set, Activity, Activity = activity.labels$Activity[Activity])

## Reordering the dataset by subject ID and activity.
merged.set <- arrange(merged.set, Subject, Activity)

## Building the tidy dataset and saving it to a file.
tidy.set <- merged.set %>% group_by(Subject, Activity) %>% summarize_each(funs(mean))
write.table(x = tidy.set,
            file = "tidy-dataset.txt")
