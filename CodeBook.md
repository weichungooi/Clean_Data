The following steps are used to combine and output summary statistics on the course dataset, which can be downloaded here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

1. test data in test.txt is read in through read.table, and dataset is named test.
2. measurements labels in features.txt are read and used to label dataset test.
3. subject data column is added to test, read in from subject_test.txt, and labelled "subject"
4. activity data column is added to test, read in from y_test.txt, and labelled "activity_label”
5. repeat these steps for train data, and dataset is named train.
6. rbind test and train data, and the combined dataset is merge_tt.
7. values in "activity_label" are replaced with corresponding descriptor like "walking", as recorded in "activity_labels.txt".
8. average and standard deviation of each measurement is calculated through fBasics's colMeans and colStdevs, under the label col_means and std. The resultant dataset is named measurement_ave_std.
9. average of each measurement, grouped by subject and activity_label, is done by a melt, and then a dcast, as follows:
a. melt the test+train database merge_tt by listing all measurements as one column, under the default name variable
b.. dcast the melted database back to wide format, and taking average of each measurement type per activity per subject
c. the resultant dataset is called merge_wide.
d. One issue with merge_wide is that only 479 of the original 561 measuremnets are returned after melt+dcast. Not sure why 82 measurements are dropped during reshape2.
