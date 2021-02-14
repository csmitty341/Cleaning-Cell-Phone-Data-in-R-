# I Utilized the guide from David Hood mentioned in the Discussion forums to structure my code 
#Load appropriate packages

library(dplyr)
library(data.table)
library(downloader)

      #Download the Data 
# I looked up the best way to read zip files and found the downloader package
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url, destfile = "phonedata.zip", mode = "wb")
unzip("phonedata.zip")

       #Read in the Files 
# I have looked at the Data with NOTEPAD ++ to visually see what I am working with
# I am going to use the read.table function. I originally tried read.delim() but kept getting only one column
# By looking at the data the first row needs to be kept, so headers should equal false
# By looking at the files, the features should be the column names for the x data
# I ran dim() on the features and x files in the console. 561 rows for features and 561 columns for X 
# Therefore I can assign the rows of the features to the column names on the x datasets
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, col.names= c("number", "measurement"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")
x_train <-read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = features$measurement)
y_train <-read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = features$measurement)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "activity")

#check Dimensions of the data 
dim(subject_train)
dim(x_train)
dim(y_train)
dim(subject_test)
dim(x_test)
dim(y_test)

# Train data has 7352 rows and test data has 2947 rows
# I am going to use rbind() to merge the data based on the rows. 
# to keep all rows aligned, must keep the test and train arguments in order
xcomb<- rbind(x_train, x_test)
ycomb <- rbind(y_train, y_test)
subjectcomb <- rbind(subject_train, subject_test)
#Once the rows are combined, use cbind() to combine columns together 
# I envision the data with the subject, activity then measurements 
datacomb <- cbind(subjectcomb, ycomb, xcomb)

#I ran the dim() and head() functions and the data appears to merge correctly

#### Now I need to pull out only the mean and STDDEV columns
# I plan on using the select function, since i added column names based off the features file 
# Looking at the data in NOTEPAD ++ if correct head() the partitioned data set should go from tBodyAcc to tGravitAcc
# I am following the script from the swirl exercises I saved, and the ?select help
# From viewing the features labels I know to look for "mean" and "std"

 clean_data <- datacomb %>%
   select(subject, activity, contains("mean"), contains("std"))
print(head(clean_data))
# In the console I ran head(clean_data), as anticpated columns jumped 
 # from the tBodyAcc to the tGravityAcc
 
# Question 3 replace the activity numbers with descriptors 
# I tried to use gsub from the lecture, it substituted the names for the value
# However it gave me only the activity column 
# I searched the mutate function applied to row values and came up with this form of code 
named_data <- clean_data %>% 
  mutate(activity = ifelse(activity == 5, "Standing", activity), 
         activity = ifelse(activity == 1, "Walking", activity), 
         activity = ifelse(activity == 2, "Walking Upstairs", activity), 
         activity = ifelse(activity == 3, "Walking Downstairs", activity), 
         activity = ifelse(activity == 4, "Sitting", activity), 
         activity = ifelse(activity == 6, "Laying", activity))

# I run a check to see if the values came out as expected. Row 1 is Standing
# Row 60 is laying 
#   head(named_data)
#   named_data[60,]

### Question 4
# In the console I ran names(named_data) to see what I need to manipulate 
# I get 88 column names 
# From the features_info File i find that t = time, acc = accelerometer, gyro = gyroscope
# mag=magnitude, f = frequency
# I am going to use the sub() command 
var_data <- named_data 
names(var_data)<- sub("tBodyAcc", "Time Body Acceleration ", names(var_data))
names(var_data)<- sub("tGravityAcc", "Time Gravity Acceleration ", names(var_data)) 
names(var_data)<- sub("tBodyGyro", "Time Body Gyroscope ", names(var_data))
names(var_data)<- sub("fBodyBody", "fBody", names(var_data))
names(var_data)<- sub("fBodyAcc", "Frequency Body Acceleration ", names(var_data))
names(var_data)<- sub("fBodyGyro", "Frequency Body Gyroscope ", names(var_data))
names(var_data)<- sub("Mag", " Magnitude ", names(var_data))
print(names(var_data))


##Question 5 
# I now need to create a new data set 
 # Going left to right I will group by the subject, then the activity
cleanedData<- var_data %>% 
  group_by(subject, activity)%>%
  summarise(across(.cols = everything(), mean)) 
      ### The above line of code I needed to google
      ##Adapted from https://www.datanovia.com/en/blog/dplyr-how-to-compute-summary-statistics-across-multiple-columns/
print(head(cleanedData))
#write the file to a text file 
write.table(cleanedData, "cleanedData.txt", row.names = FALSE)
 