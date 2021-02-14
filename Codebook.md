# This is the Codebook for the run Analysis script

Packages utilized 
  - Downloader
  - dplyr

The UCI HAR Dataset comes in a .zip file that must be unpackaged
  - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

The scipt executes the following analysis
  1.  Reads the training and test data into defined variables 
      -  features : List 1 column, 561 rows; contains the variables measures along the x, y , and z axis
      -  subject_train : List of 1 column, 7352 rows; this identifies the individual device the measurements come from 
      -  x_train : Contains 7352 rows and 561 columns; these are the recorded measurements for the training data
      -  y_train : Contains 7352 rows and 1 column; identifies the activity (Walking, sitting, Laying, etc.) 
      -  subject_test : List of 1 column, 2947 rows; this identifies the individual device the measurements come from 
      -  x_test : Contains 2947 rows and 561 columns; these are the recorded measurements for the test data
      -  y_test : Contains 2947 rows and 1 column; identifies the activity (Walking, sitting, Laying, etc.)
  
  2. Combines the training and test data
      -  x_comb : binds the test data below the rows of the training data
      -  y_comb : binds the test data below the rows of the training data
      -  subject_comb : binds the test data below the rows of the training data
      -  outputs a combined dataset called datacomb
  
  3. Replaces the activity names with their labels from the activity_labels.txt file in the zip folder
      -  named_data : mutates the data to replaced the numerical value with the activity label
  
  4. Assigns more descriptive labels to the variable names. Descriptors are obtained from the features_info.txt file
      -  var_data : dataset modified with descriptive variable names 
  
  5. Extracts a new data set which provides the mean and standard deviation for each device and activity
      -  cleanedData : Dataset that takes the var_data groups by subject and activity, then takes the average for each variables
      -  outputs a cleanedData.txt file to the working directory


