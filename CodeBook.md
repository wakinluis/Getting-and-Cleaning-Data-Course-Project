# CodeBook for Getting and Cleaning Data Course Project
This document serves as a codebook for the dataset. It describes the variables included, provides details about the data, and outlines any transformations or data cleaning steps that were performed. Use this codebook as a reference to understand the structure and processing of the dataset.

 This function processes the Human Activity Recognition Using Smartphones Dataset, available at
 * http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.


## File Handling
- The `file_handle.R` file will serve as the main component for downloading and unzipping the dataset.
- It consists of a function called `get_data()` where it goes through a condition if each required files are present


## Data Exploration
* The following extracted files from `dataset.zip` consists of the following:

        UCI HAR Dataset

            test
                subject_test.txt
                X_test.txt
                y_test.txt

            train
                subject_train.txt
                X_train.txt
                y_train.txt

            activity_labels.txt
            features.txt
            features_info.txt
            README.txt
- There is a total of 561 rows in `features.txt`, each representing a feature label.
- The test and training dataset was split to 70% for training, and 30% for testing.
- The test split consist of 2,947 rows.
- The train split consist of 7,352 rows.
- Collectively, the unfiltered data consist of 10,299 rows.

## Data Processing Steps
1. **Merge Test and Train Datasets**  
    - After retrieving required files, read each .txt file present from the zip file
    - For the metadata, we use `activity_labels.txt` and `features.txt`
    - `activity_labels.txt` consists of the following:
      
          WALKING
          WALKING_UPSTAIRS
          ALKING_DOWNSTAIRS
          SITTING
          STANDING
          LAYING
    - By labeling each respective columns, label the train and test sets with the following features retrieved from `features.txt`, these are labeled based on the columns of both sets with the rows of features.
    - Combine the test and train data with `cbind()` of their three .txt files found in their respective folder
    - Merge both test and train into one table using `rbind()`
    - The merged data will result to 563 columns, and 10,299 rows.
      
2. **Filter Data**
    - Filter the data using the selected mean and standard deviation measurements
    - Using `grep()` it searches through these column names for any that match the regular expression "mean\\(\\)|std\\(\\)".
    - `value = TRUE` tells `grep()` to return the actual matching column names and not just indices
    - After filtering, 68 features were present, filtering 495 columns.
      
3. **Apply Descriptive Activity Names**
    - This portion adds a column of the `activity` values based on the `activityID` using `merge()`.
      
4. **Label Data with Descriptive Variable Names**
    - Using `gsub()` to replace all matches of each patterns into a readable format.
    - It will elaborate each shortened column names for better comprehension.
      
5. **Create Tidy Dataset with Average of Each Variable for Each Activity and Each Subject**
    - Using `group_by()` to group both subject and activity
    - Summarize each group using `summarize()` by calculating the mean of every variable
    - Returning it to a regular data frame using `ungroup()`
    - Write the output of the tidy data to `tidy_data.txt`
