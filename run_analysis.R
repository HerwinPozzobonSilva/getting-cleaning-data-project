##==========================================================================================
#  Getting and Cleaning Data - Johns Hopkins Bloomberg School of Public Health and Coursera
#  The run_analysis script for the Human Activity Recognition Using Smartphones Data Set 
#  By: Herwin Pozzobon Silva
#  Date: 2015-03-21
#  Version: 1.5
#  Important remarks: it is assumed that all the packages are installed and available
##==========================================================================================
#
#
#
#-------------------------------------------------------
# The first step: getting the file and uncompressing it
#-------------------------------------------------------
#
            # clean the environment
rm(list=ls())

            # this will be the name of the working directory for the run_analysis script
raDir <- "Run_Analysis"

            # this is the actual working diretory
wdDir <-getwd()

            # if Run_Analysis directory dos not exists then create it
            # under the actual diretory
if (!file.exists(raDir)) dir.create(file.path(wdDir, raDir))

            # now we go to the Run_analysis work directory
setwd(file.path(wdDir, raDir))

            # this is the URL of the "Human Activity Recognition Using Smartphones Data Set"
            # wich is the zip file to be downloded
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
            
            # if the zip file "Human Activity Recognition Using Smartphones Data Set" (HARUS_DS)
            # does not exists then download it
if (!file.exists("HARUS_DS.zip")) download.file(zipFileUrl, destfile="HARUS_DS.zip")

            # if the zip file is downloaded but still compressed, then uncompress it
if (!file.exists("UCI HAR Dataset")) unzip("HARUS_DS.zip")
#
#
#
#-------------------------------------------------------
# The second step: reading and merging the ".txt" files
# and assembling the final data set
#-------------------------------------------------------
#
            # the training data files
trn_x       <- read.table("UCI HAR Dataset//train/X_train.txt", comment.char="")
trn_subject <- read.table("UCI HAR Dataset//train/subject_train.txt", col.names=c("subject"))
trn_y       <- read.table("UCI HAR Dataset/train//y_train.txt", col.names=c("activity"))
trn_final   <- cbind(trn_x, trn_subject, trn_y)

            # the test data files
tst_x       <- read.table("UCI HAR Dataset//test/X_test.txt", nrows=2947, comment.char="")
tst_subject <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"))
tst_y       <- read.table("UCI HAR Dataset/test//y_test.txt", col.names=c("activity"))
tst_final   <- cbind(tst_x, tst_subject, tst_y)

            # assembling the final data table
harus_dt    <- rbind(trn_final, tst_final)


#-------------------------------------------------------
# The third step: getting only the data needed for the
# analysis: mean and std deviation for each measure
#-------------------------------------------------------
#
            # the file with all the features
features    <- read.table("UCI HAR Dataset//features.txt", col.names = c("id", "name"))
            # only de features needed
onlyFeatNeed<- c(as.vector(features[, "name"]), "subject", "activity")

# filter only features that has mean or std in the name
filtFeat    <- grepl("mean|std|subject|activity", onlyFeatNeed) & !grepl("meanFreq", onlyFeatNeed)
filtData    <- harus_dt[, filtFeat]

#-------------------------------------------------------
# The fourth step: naming the activities in the data set
# 
#-------------------------------------------------------
#
act         <- read.table("UCI HAR Dataset//activity_labels.txt", col.names=c("id", "name"))
for (i in 1:nrow(act)) {
   filtData$activity[filtData$activity == act[i, "id"]] <- as.character(act[i, "name"])
}

#-------------------------------------------------------
# The fifth step: naming/labeling the data set columns
# 
#-------------------------------------------------------
#
myColNames  <- onlyFeatNeed[filtFeat]
myColNames <- gsub("\\(\\)", "", myColNames)
myColNames <- gsub("Acc", "-acceleration", myColNames)
myColNames <- gsub("Mag", "-Magnitude", myColNames)
myColNames <- gsub("^t(.*)$", "\\1-time", myColNames)
myColNames <- gsub("^f(.*)$", "\\1-frequency", myColNames)
myColNames <- gsub("(Jerk|Gyro)", "-\\1", myColNames)
myColNames <- gsub("BodyBody", "Body", myColNames)
myColNames <- tolower(myColNames)
names(filtData) <- myColNames

#-------------------------------------------------------
# The sixth step: generating the final tidy data set
# 
#-------------------------------------------------------
#
finalData   <- tbl_df(filtData) %>%
   group_by('subject', 'activity') %>%
   summarise_each(funs(mean)) %>%
   gather(measurement, mean, -activity, -subject)

write.table(finalData, file="finalData", row.name=FALSE)
