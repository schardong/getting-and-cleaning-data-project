# Getting and Cleaning Data Course Project
Getting and Cleaning Data Course Project

## Introduction, Dataset and Required Packages

The scripts contained in this repository are part of the course project for the Getting and Cleaning data course made available by the John Hopkins university (accessible [here](https://www.coursera.org/learn/data-cleaning/home/welcome)). The mandatory script, called *run_analysis.R* sources the optional *pre_run_reqs.R* script that verifies if the necessary packages are installed and loads (or installs) them. The packages needed to run the scripts are:

	1. *dplyr*
	2. *readr*
	3. *tidyr*
	4. *stringr*

Some guidelines to do this assignment were drawn from David Hood's webpage [1].

The dataset codebook is described in the *CodeBook.md* file in this repository. This file contains a dictionary explaining the variables included in the tidy dataset generated, together with a brief description and ranges of each variable. 

## Analysis Tasks Explained

The analysis starts by creating a **data** folder under the current working directory, downloading the dataset (hosted at [2]) and unzipping it. A more thorough README for this dataset is available at [2].

The next processing steps involve reading in the features names (in the *features.txt* file) and possible activity labels (in the *activity_labels.txt* file). For both of these attributes, we replace the minus signs for underscores in order to better work with dplyr in a future analysis. For the **features** data, we also remove the parenthesis present in some feature names. The features will act as column names for our dataset, while the activity labels will be appended as a new column at the beginning of the dataset.

Next, we read in the training and test datasets. Both of the original files (*X_(train/test).txt*) are read line-by-line using the **readLines** function call. we then split each line by the whitespace character and cast them to the numeric type, using the **as.numeric** function call. Both sets activities and subjects are read from their respective files (*y_(train/test).txt* and *subject_(train/test).txt*) and appended as columns to the datasets. The data is then merged by a **rbind** call.

To extract only the mean and standard deviation columns, we use the **grep** function on the variable names and using another **grep** call, we remove the columns with *Freq* in their names, retaining only the *mean* and *std* columns. The remaining columns are discarded from the merged dataset. Then we replace the activity column, which was composed of numbers, by their human-readable labels given by the **activity.labels** table. As a cosmetic change, we arrange the dataset in a way that places the subject identifier and activity label as the first columns of the dataset, named **Subject** and **Activity** respectively.

The tidy dataset is produced by first grouping the dataset by the **Subject** and **Activity** columns, to calculate the means of the distributions, we call the **sumarize_each** function, which produces the mean values by activity and subject of the dataset. The resulting dataset has 180 observations and 68 variables and is saved to the *tidy-dataset.txt* file.

This dataset meets the principles described during the course and in J.T. Leek's **datasharing** repository in [3], namely:
	
	1. Each variable is one column in the dataset;
	2. Each observation is one row in the dataset;
	
Since our dataset does not involve multiple tables, principles 3 and 4 are left out of our list.

To read the processed dataset, a simple call to **read.table** with the default parameters, except the **header** parameter, which should be set to **TRUE**, should work.

## References

[1] Hood, David; **Getting and Cleaning the Assignment**; URL: [https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

[2] [UCI Human Activity Recognition Using Smartphones Homepage](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[3] Leek, J. T.; **Datasharing repository**; URL: [https://github.com/jtleek/datasharing](https://github.com/jtleek/datasharing)
