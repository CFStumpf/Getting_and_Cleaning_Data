## This script will take data from multiple .txt files and combine them in to a 
## single tidy data set.

 ## check for reshape2 package being installed

if (!("reshape2" %in% rownames(installed.packages())) ) {
  print("Please install required package \"reshape2\" before proceeding")
} else {

 ## read all of the training data and combine it into a single table
  
  trainx<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/train/X_train.txt")
  trainy<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/train/y_train.txt")
  trainsub<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/train/subject_train.txt")
  train_combined<- cbind(trainx, trainy, trainsub)
  
  ## read all of the test data and combine it into a single table
  
  testx<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/test/X_test.txt")
  testy<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/test/Y_test.txt")
  testsub<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/test/subject_test.txt")
  test_combined<- cbind(testx, testy, testsub)
  
  ## read all of the features and activities data and label them
  
  features<-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  activity <-read.table("~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/activity_labels.txt")
  names(activity) <- c("activity", "description")
  
  ## bind together the data from the test and training frames
  
  cleandata <- rbind(train_combined, test_combined)
  names(cleandata)[1:561] <- features[,2]
  names(cleandata)[562:563]<- c("y", "subject")
  
  ## searches the newly combined data for the appropriate mean and standard deviation data
  
  mean_list <- names(cleandata)[grep("-mean()",names(cleandata))]
  mean_pos <- grep("-mean()",mean_list)
  exclude_list <- grep("Freq()",mean_list)
  pos_vector <- setdiff(mean_pos,exclude_list)
  
  mean_list <- mean_list[c(pos_vector)]
  std_list <- names(cleandata)[(grep("-std()",names(cleandata)))]
  
  ##creates final data set
  
  final_data <- cbind(cleandata[,c(mean_list)], cleandata[,c(std_list)], cleandata[,562], cleandata[,563])
  
  names(final_data)[67:68]<- c("activity", "subject")
  
  final_data$activity <- activity[final_data$activity,2]
  
  melted_data <- melt(final_data,id= c("subject", "activity"))
  casted_data <- dcast(melted_data, subject + activity~ variable, mean)
  
  ## creates the approproately cleaned up text file and places it in working directory
  
  write.table(casted_data, file = "~/Data Science/3. Getting and Cleaning Data/Peer Assessment/UCI HAR Dataset/tidy_data.txt", sep = "\t", row.names = FALSE)
  
  casted_data}