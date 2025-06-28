get_data <- function() {
  # Download zip if it doesn't exist
  if (!file.exists("dataset.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "dataset.zip")
  }
  
  # Unzip if the dataset folder doesn't exist
  if (!file.exists("UCI HAR Dataset")) {unzip("dataset.zip", exdir = ".")}
}

