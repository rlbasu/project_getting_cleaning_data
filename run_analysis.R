#download file and put in the folder named data in the directory
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#unzip the file "Dataset.zip"
unzip(zipfile = "./data/Dataset.zip", exdir = "./data")

#unzipped folder is "UCI HAR Dataset"
#get the list of files in that folder
filePath = file.path("./data", "UCI HAR Dataset")
files = list.files(filePath,recursive=TRUE)
files

#read files(activity, subject,features) for Test and Train
ActivityTest = read.table(file.path(filePath, "test","Y_test.txt"), header =FALSE)
ActivityTrain = read.table(file.path(filePath, "train","Y_train.txt"), header =FALSE)
SubjectTest = read.table(file.path(filePath, "test","subject_test.txt"), header =FALSE)
SubjectTrain = read.table(file.path(filePath, "train","subject_train.txt"), header =FALSE)
FeaturesTest = read.table(file.path(filePath, "test","X_test.txt"), header =FALSE)
FeaturesTrain = read.table(file.path(filePath, "train","X_train.txt"), header =FALSE)

#use str function to check the properties of variables
str(ActivityTest)
str(ActivityTrain)
str(SubjectTest)
str(SubjectTrain)
str(FeaturesTest)
str(FeaturesTrain)
#merge the training and test data set so to create one new data set
#merge data table by using row bind

SubjectData = rbind(SubjectTrain, SubjectTest)
ActivityData = rbind(ActivityTrain, ActivityTest)
FeaturesData = rbind(FeaturesTrain, FeaturesTest)

#set names for the variables
names(SubjectData) = c("subject")
names(ActivityData) = c("activity")
namesFeaturesData = read.table(file.path(filePath, "features.txt"), head = FALSE)
names(FeaturesData) = namesFeaturesData$V2

#merge using column bind
CombineData = cbind(SubjectData,ActivityData)
MergedData = cbind(FeaturesData, CombineData)

#Extracts only the measurements on the mean and standard deviation for each measurement.
subnameFeaturesData = namesFeaturesData$V2[grep("mean\\(\\)|std\\(\\)", namesFeaturesData$V2)]
selectedNames = c(as.character(subnameFeaturesData), "subject", "activity")
MergedData = subset(MergedData, select = selectedNames)
str(MergedData)

#Uses descriptive activity names to name the activities in the data set
activityNames = read.table(file.path(filePath, "activity_labels.txt"), header = FALSE)
head(MergedData$activity,30)

#Appropriately labels the data set with descriptive variable names
names(MergedData)<-gsub("^t", "time", names(MergedData))
names(MergedData)<-gsub("^f", "frequency", names(MergedData))
names(MergedData)<-gsub("Acc", "Accelerometer", names(MergedData))
names(MergedData)<-gsub("Gyro", "Gyroscope", names(MergedData))
names(MergedData)<-gsub("Mag", "Magnitude", names(MergedData))
names(MergedData)<-gsub("BodyBody", "Body", names(MergedData))
names(MergedData)

#create new tidy datset
library(plyr);
Data2<-aggregate(. ~subject + activity, MergedData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)







