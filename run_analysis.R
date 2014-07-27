#This script reads test data (test.txt) and train data (train.txt), adds to them subject and activity labels,
#then combines them through rbind.
#average and standard deviation for each measurement of activity are then calculated, and stored in activity_ave_std
#a second data set is then created with the average of each variable for each activity and each subject

#activity here refers to walking, walking_upstairs etc.
#measurement type refers to tBodyAcc-mean()-Y, etc
#measurement refers to the vaules of the measurement type

require('fBasics')
require('reshape2')
#require('plyr')

#Read in test data, measurement (test) names and subject.
test <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", sep="")
test_subject <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", sep="", stringsAsFactors = FALSE)
test_names<-read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", sep="", stringsAsFactors = FALSE)
names(test)<-test_names$V2
test$subject<-test_subject$V1
test_activity_label <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", sep="")
test$activity_label<-test_activity_label$V1


#Read in train data, measurement (test) names and subject.
train <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", sep="")
train_subject <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", sep="", stringsAsFactors = FALSE)
names(train)<-test_names$V2 #measurement names are the same as test set. Reuse.
train$subject<-train_subject$V1
#Read in activity labels, and replace them with corresponding activity in words
train_activity_label <- read.table("C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", sep="")
train$activity_label<-train_activity_label$V1

#merge train and test data
merge_tt<-rbind(test, train)
#Replace activity label code them with corresponding description
merge_tt$activity_label[merge_tt$activity_label==1]<-"Walking"
merge_tt$activity_label[merge_tt$activity_label==2]<-"Walking_Upstairs"
merge_tt$activity_label[merge_tt$activity_label==3]<-"Walking_Downstairs"
merge_tt$activity_label[merge_tt$activity_label==4]<-"Sitting"
merge_tt$activity_label[merge_tt$activity_label==5]<-"Standing"
merge_tt$activity_label[merge_tt$activity_label==6]<-"Lying"

#Calculate each measurement's average and mean  
col_means<-colMeans(subset(merge_tt, select=test_names$V2))
std<-colStdevs(subset(merge_tt,select=test_names$V2))
measurement_ave_std<-rbind(col_means, std)
write.table(measurement_ave_std,"C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/measurement_ave_std.txt", sep="\t")

#Calculate average of each measurment type for each subject for each activity using the following:
#1. melt the test+train database by listing all measurements as one column, under the default name variable
#2. dcast the melted database back to wide format, and taking average of each measurement type per activity per subject
merge_long<-melt(merge_tt,id.vars=c("subject","activity_label"))
merge_wide<-dcast(merge_long,subject+activity_label~variable, fun.aggregate=mean)

write.table(merge_wide,"C:/Users/Ooi_Desktop/R/dataset/Ooi/Class/Clean_data/subject-activity_average.txt", sep="\t")
