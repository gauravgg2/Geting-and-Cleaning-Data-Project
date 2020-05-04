This is a codebook for the project in getting and cleaning data course

First of all required libraries are loaded in R

Thereafter working directory is set using setwd command

And then one by one different txt files are readed such as

activity_labels.txt is read as "activity" with column names as
"act_label" representing activity number and  "act_name" representing individual activities
#activity<-fread("activity_labels.txt",col.names = c("act_label","act_name"))

features.txt is read as "features" with column names as 
"feat_no" representing feature number and "feat_label" representing individual features 
#features<-fread("features.txt",col.names = c("feat_no","feat_label"))

After that training data is loaded as "Xtrain" for X_train.txt fle in subfolder train
and training labels as Ytrain for Y_train.txt file in same subfolder
Along with this sujects data is also loaded/read as"sub_train" from subject_train.txt
#Xtrain<-fread("train/X_train.txt")
#Ytrain<-fread("train/Y_train.txt")
#sub_train<-fread("train/subject_train.txt")

After this testing data is loaded as "Xtest" for X_test.txt file in subfolder test
and testing labels as Ytest for Y_test.txt file and along with this subjects data as"sub_test" from subject_test.txt
#Xtest<-fread("test/X_test.txt")
#Ytest<-fread("test/Y_test.txt")
#sub_test<-fread("test/subject_test.txt")

once all data is loaded in, we start to merge the data as needed.
At first we merge Xtrain and Xtest data using rbind into "X"
then, we mere Ytrain and Ytest data again using rbind into "Y"
Then comes subject data, which is merged into "subject" using rbind
#l<-list(Xtrain,Xtest)
#X<-rbindlist(l)
#Y<-rbind(Ytrain,Ytest)
#subject<-rbind(sub_train,sub_test)

once data is loaded we, name the columns for Y as act since it identifies the act subjects were doing
and columns of "subject" as sub for easy access later on if needed be.
#colnames(Y)<-"act"
#colnames(subject)<-"sub"

Second task for us is to extract mean and std for each measurement 
To do this we first need to identify which columns in X are representing mean or std,
so we do a grep to find out all those factors in features data frame which contain mean or std in their description
we store output of this grep in "extractedv" to represent extracted Vectors which contain mean or std.
#extractedv<-grep("mean|std",features$feat_label)

We then subset our datset X with only these extracted vectors

#X1<-X[,..extractedv]


After this we replace default column names in X with properly described names extracted from features data frame.
#var_name<-features$feat_label[extractedv]
#names(X1)<-var_name

After this we are asked to describe the activity in combined dataset X with descriptive names insted of numerical.
To do this we need to do a join of dataset X and activity , but doing so also rearranges the data, 
so we first do a column bind of X, Y, subjects, so that no confusion is created at later stage with joined data.
After this we do join using merge function by "act" column name in X and "act_label" column name in activity.
#ds<-cbind(X1,Y,subject)
#ds1<-merge(ds,activity,by.x = "act",by.y = "act_label",all.x = TRUE)


After this we are tasked with replacing defalt vector names in combined dataset with descriptive names,
since we are already done with this, we wont do it again, but will refine the descriptive names a little more using gsub command
#t<-gsub("-mean()","Mean",names(ds1))
#t<-gsub("-std()","Std",t)
#names(ds1)<-t

At last we need to create a tidy dataset, as per lectures we can do that using melt function,
so we do that with id variables as "sub","act","act_name".
#tidy<-melt(ds1,id=c("act","act_name","sub"))

After that we need to find average of each variable for each activity and each subject so we do this using cast function.
#v<-cast(tidy,act+act_name~sub,mean)


and at last write back our tidy dataset onto tidy.txt file
#write.table(v,file="tidy.txt",quote = FALSE)
