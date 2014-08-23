## read training data
traindata<-read.table("./data/UCI HAR Dataset/train/X_train.txt")


##add activity and subject to traindata
trainact<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainsubject<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
traindata[,562]=trainact
traindata[,563]=trainsubject

##read test data
testdata<-read.table("./data/UCI HAR Dataset/test/X_test.txt")

## add activity and subject to test data
testact<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
testsubject<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
testdata[,562]=testact
testdata[,563]=testsubject

## merge training data and test data
alldata<-rbind(traindata,testdata)


##extracts only measurements on mean and std
features<-read.table("./data/UCI HAR Dataset/features.txt")
colnames(alldata)<-features$V2
colnames(alldata)[562]<-"activity"
colnames(alldata)[563]<-"subject"

usefeatures<-grepl("mean\\(\\)|std\\(\\)",features[,2])
usecol<-c(usefeatures,562,563)
usedata<-alldata[,usecol]

##use decriptive names to name all data activity
actlabel<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(actlabel)<-c("activity","activity_name")
actdata<-merge(usedata,actlabel,all=TRUE)

##create a tidy data set with average of each variable for
usedata$subject<-as.factor(usedata$subject)
usedata$activity<-as.factor(usedata$activity)
tidydata<-aggregate(usedata,by=list(activity_id=usedata$activity,subject_id=usedata$subject),mean)
tidydata$activity<-NULL
tidydata$subject<-NULL


##save tidydata as txt
write.table(tidydata,row.names=FALSE, "tidy.txt", sep="\t")









