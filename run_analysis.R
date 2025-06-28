## check if dplyr package is installed
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

## Use dplyr and file handling
library(dplyr)
source("file_handle.R")

## Retrieves dataset, refer to file_handle.R
get_data()

## ------------- 1. Merge Test and Train Datasets -------------
## Read metadata
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

## Label activity labels
names(activity_labels) <- c("activityID", "activity")
## check if reflected correctly
# names(activity_labels)

## Read testing set
subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

## Read training set
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

## Check if features matches column count
if(ncol(X_test) == nrow(features)) {"Matched"} else {"Mismatch"}
if(ncol(X_train) == nrow(features)) {"Matched"} else {"Mismatch"}

## label X_test and X_train to corresponding features
names(X_test) <- features[,2]
names(X_train) <- features[,2]

## Check unique values are corresponding to activityID
unique(y_test)
unique(y_train)
## label y_test and y_train to activityID
names(y_test) <-"activityID"
names(y_train) <- "activityID"

## check subject range, subjects indicated to range from 1-30, refer to README.txt
unique(subj_test)
unique(subj_train)
names(subj_test) <- "subjID"
names(subj_train) <- "subjID"

## merging each .txt file into one table
test_data <- cbind(subj_test, y_test, X_test)
train_data <- cbind(subj_train, y_train, X_train)
merged_data <- rbind(test_data, train_data)

## get column and row count
ncol(merged_data)
nrow(merged_data)

## ------------- 2. Filter Data -------------
## Filter data using selected mean and standard deviation measurements
selected_columns <- grep("mean\\(\\)|std\\(\\)", names(merged_data), value = TRUE)
filtered_data <- merged_data[, c("subjID", "activityID", selected_columns)]
ncol(filtered_data)
nrow(filtered_data)

##------------- 3. Apply Descriptive Activity Names -------------
named_data <- merge(filtered_data, activity_labels, by = "activityID", all.x = TRUE)
named_data <- filtered_data %>%
  select(subjID, activity, everything(), -activityID)

## Check if activity names are applied correctly
head(named_data$activity)

names(named_data)

##------------- 4. Label Data with Descriptive Variable Names -------------
## gsub() to replace all matches of mentioned pattern into a readable format
names(named_data) <- gsub("^t", "time", names(named_data))
names(named_data) <- gsub("^f", "frequency", names(named_data))
names(named_data) <- gsub("Acc", "Accelerometer", names(named_data))
names(named_data) <- gsub("Gyro", "Gyroscope", names(named_data))
names(named_data) <- gsub("Mag", "Magnitude", names(named_data))
names(named_data) <- gsub("BodyBody", "Body", names(named_data))
names(named_data) <- gsub("mean\\(\\)", "Mean", names(named_data))
names(named_data) <- gsub("std\\(\\)", "StandardDeviation", names(named_data))
names(named_data) <- gsub("-", "", names(named_data))
names(named_data) <- gsub(" ", "", names(named_data))
## Check if names are applied correctly
names(named_data)

##------------- 5. Create Tidy Dataset with Average of Each Variable for Each Activity and Each Subject -------------
tidy_data <- named_data %>%
  group_by(subjID, activity) %>%
  summarise(across(everything(), mean, na.rm = TRUE)) %>%
  ungroup()

## Check if tidy_data is created correctly
ncol(tidy_data)
nrow(tidy_data)

## Write tidy_data to a text file
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)
## Check if tidy_data is written correctly
if (file.exists("tidy_data.txt")) {
  message("Tidy data file created successfully.")
} else {
  message("Failed to create tidy data file.")
}



