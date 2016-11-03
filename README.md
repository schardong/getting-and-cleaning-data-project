# Getting and Cleaning Data Course Project
Getting and Cleaning Data Course Project

## Introduction, Dataset and Required Packages

The scripts contained in this repository are part of the course project for the Getting and Cleaning data course made available by the John Hopkins university (accessible [here](https://www.coursera.org/learn/data-cleaning/home/welcome)). The mandatory script, called *run_analysis.R* sources the optional *pre_run_reqs.R* script that verifies if the necessary packages are installed and loads (or installs) them. The packages needed to run the scripts are:

1. *dplyr*
2. *readr*
3. *tidyr*
4. *stringr*

## Analysis Tasks Explained

The analysis starts by creating a **data** folder under the current working directory, downloading the dataset (hosted at [1]) and unzipping it. A README for this dataset is available at [2].

The next processing steps involve reading in the features names (in the *features.txt* file) and possible activity labels (in the *activity_labels.txt* file). For both of these attributes, we replace the minus signs for underscores in order to better work with dplyr in a future analysis. For the **features** data, we also remove the parenthesis present in some feature names. The features will act as column names for our dataset, while the activity labels will be appended as a new column at the beginning of the dataset.

Next, we read in the training and test datasets. Both of the original files (*X_(train/test).txt*) are read line-by-line using the **readLines** function call. we then split each line by the whitespace character and cast them to the numeric type, using the **as.numeric** function call. Both sets activities and subjects are read from their respective files (*y_(train/test).txt* and *subject_(train/test).txt*) and appended as columns to the datasets. The data is then merged by a **rbind** call.

To extract only the mean and standard deviation columns, we use the **grep** function on the variable names and using another **grep** call, we remove the columns with *Freq* in their names, retaining only the *mean* and *std* columns. The remaining columns are discarded from the merged dataset. Then we replace the activity column, which was composed of numbers, by their human-readable labels given by the **activity.labels** table. As a cosmetic change, we arrange the dataset in a way that places the subject identifier and activity label as the first columns of the dataset, named **Subject** and **Activity** respectively.

The tidy dataset is produced by first grouping the dataset by the **Subject** and **Activity** columns, to calculate the means of the distributions, we call the **sumarize_each** function, which produces the mean values by activity and subject of the dataset. The resulting dataset has 180 observations and 68 variables and is saved to the *tidy-dataset.txt* file.

[1] [Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

[2] [UCI Human Activity Recognition Using Smartphones Homepage](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
