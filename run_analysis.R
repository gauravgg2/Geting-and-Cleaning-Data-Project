# loading libraries
library(dplyr)
library(data.table)
library(reshape)
library(reshape2)

# reading data
setwd("C:/Users/Gaurav/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
activity<-fread("activity_labels.txt",col.names = c("act_label","act_name"))
features<-fread("features.txt",col.names = c("feat_no","feat_label"))
#feat_info<-fread("features_info.txt",col.names = c())
getwd()
Xtrain<-fread("train/X_train.txt")
Ytrain<-fread("train/Y_train.txt")
sub_train<-fread("train/subject_train.txt")
Xtest<-fread("test/X_test.txt")
Ytest<-fread("test/Y_test.txt")
sub_test<-fread("test/subject_test.txt")

#Merges the training and the test sets to create one data set.
l<-list(Xtrain,Xtest)
X<-rbindlist(l)
Y<-rbind(Ytrain,Ytest)
subject<-rbind(sub_train,sub_test)
colnames(Y)<-"act"
colnames(subject)<-"sub"

#Extracts only the measurements on the mean and standard deviation for each measurement.
extractedv<-grep("mean|std",features$feat_label)
X1<-X[,..extractedv]

#Appropriately labels the data set with descriptive variable names. 
var_name<-features$feat_label[extractedv]
names(X1)<-var_name


#Uses descriptive activity names to name the activities in the data set
#we are binding the whole data since merging will reshuffle the data
ds<-cbind(X1,Y,subject)
ds1<-merge(ds,activity,by.x = "act",by.y = "act_label",all.x = TRUE)
t<-gsub("-mean()","Mean",names(ds1))
t<-gsub("-std()","Std",t)
names(ds1)<-t
#creates a second, independent tidy data set with the average
#of each variable for each activity and each subject.
tidy<-melt(ds1,id=c("act","act_name","sub"))
v<-cast(tidy,act+act_name~sub,mean)
write.table(v,file="tidy.txt",quote = FALSE)