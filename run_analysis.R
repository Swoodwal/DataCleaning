library(dplyr)
xtrain<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/train/X_train.txt', header=FALSE)
ytrain<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/train/y_train.txt', header=FALSE)

xtest<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/test/X_test.txt', header=FALSE)
ytest<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/test/y_test.txt', header=FALSE)
# get features data
features<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/features.txt', header=FALSE)
# get activity data
activity<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/activity_labels.txt', header=FALSE)
# get subject data
trains<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/train/subject_train.txt', header=FALSE)
trains<-trains%>%
  rename(subjectID=V1)
tests<-read.table('C:/Users/sidak/Documents/getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset/test/subject_test.txt', header=FALSE)
tests<-tests%>%
  rename(subjectID=V1)

features<-features[,2]
featrasp<-t(features)
colnames(xtrain)<-featrasp
colnames(xtest)<-featrasp
colnames(activity)<-c('id','actions')

combineX<-rbind(xtrain, xtest)
combineY<-rbind(ytrain, ytest)
combineSubj<-rbind(trains,tests)

YXdf<-cbind(combineY,combineX, combineSubj)

df<-merge(YXdf, activity,by.x = 'V1',by.y = 'id')
colNames<-colnames(df)
dftwo<-df%>%
  select(actions, subjectID, grep("\\bmean\\b|\\bstd\\b",colNames))

dftwo$actions<-as.factor(dftwo$actions)

colnames(dftwo)<-gsub("^t", "time", colnames(dftwo))
colnames(dftwo)<-gsub("^f", "frequency", colnames(dftwo))
colnames(dftwo)<-gsub("Acc", "Accelerometer", colnames(dftwo))
colnames(dftwo)<-gsub("Gyro", "Gyroscope", colnames(dftwo))
colnames(dftwo)<-gsub("Mag", "Magnitude", colnames(dftwo))
colnames(dftwo)<-gsub("BodyBody", "Body", colnames(dftwo))

df22<-aggregate(.~subjectID+actions,dftwo,mean)

write.table(df22, file = "tidydata.txt",row.name=FALSE)