# Repository Name: TitdyDataSet_Assignment2
# Purpose: Coursera Course Project: Getting and Cleaning Data.
# This repository is for demonstrating the ability to clean a data set.
#    Contents of the Repository.
 1) README.md: Description of the purpose and contents of this
repository.
 2) run_analysis.R: This is the script to 
  a) download and unzip the datafile if necesary.
  b) It will place the dataset in the working directory
  c) The folder has the name which was in the downladed file.


  3) tidy_data_set.txt: This is a comma delimeted file created by the program run_analysis.R. 

  4) Codebook.txt: This is the codebook for the dataset with
   definitions and explanations for the creation of the dataset.
 5) As per instructions, this R$EADME file contains has teh description of how run_analysis.R works. THis description is also included in the codebook.pdf.
 




Code Book for Project 
Contents
Introduction:	2
Process:	2
Data Dictionary: Description of Variables:	5

DESCRIPTION of How Program run_analysis.R works. Please see attached pdf which is better formatted.
1.	Load R packages:
a.	dplyr
b.	stringr
2.	Create the data directory “. /data” if does not already exist in the current working directory. 
3.	If the file Dataset.zip does not already exist in the data directory, then download it using download.file with the mode set to “wb” from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" and unzip it. Otherwise, do not download it.
4.	The data will be in a directory in the current folder called “UCI HAR Dataset”. It contains the files and folders for the analysis. 
a.	README.txt
b.	activity_labels.txt: These are the factors used to describe the activity the tester was engaging in at the time the measurement was made.
c.	features.txt: The variable names for the measurements in X_train.txt and X_test.txt.
d.	features_info.txt: A description of the variables in features.txt.
e.	folder – train: contains the training data sets.
i.	subject_train: A file listing which tester conducted the test in each row.
ii.	y_train: A file listing the activity the tester was engaged in for each row.
iii.	X_train: A file containing the measurements as described in the README.txt file downloaded with the data set.
f.	folder –test : contains the testing datasets:
i.	subject_test: A file listing which tester conducted the test in each row.
ii.	y_test: A file listing the activity the tester was engaged each row.
iii.	X_test: A file containing the measurements as described in the README.txt file
5.	Read the activity_labels.txt file into the data frame activity_labels using read.csv. It contains two columns a numerical value for the factor (1:6) as represented in the y_train.txt and y_test.txt and the corresponding descriptive label for the activity. We will use these descriptive labels to replace the numbers in the y_train and y_test dataset with the descriptsions. 
a.	Assign it the column names Record and ActivityType.
b.	Print the file to view it contents.
6.	Read the activity file y_train.txt and assign it to the data frame y_train.  
a.	Assign it the column name Activity
b.	The number of levels in this file is 6 listed as the numbers 1:6.
c.	Rename the levels using the function factor with the levels and names coming from the activity_labels data set as described above. 
7.	Load in the features.txt file into the features data frame using read.csv with the option header = FALSE. Since I used header=FALSE the default column names are V1, and V2 which I use for them. The second column V2 column contains the names that we will use for our data measurements. We will condition these names in this data frame features as follows :  
a.	Remove unwanted characters using the local function f_remove_chars. This function removes the following characters :
1.	(
2.	)
3.	,
4.	1 or more spaces in a row
5.	Hyphen –
6.	Underscore _
7.	Trims any leading and training spaces using str_trim from the stringr package.
b.	Since Camel Code seems to the agreed on standard for variable names, then variable names in the df y_train will be changed. Let it be noted that some people prefer all lower case. I changed to camel code because of the forums for the course. Also note that after we subset the columns to only the ones that we want, later there will only be four words which need to be fixed.
1.	mean to Mean
2.	std to Std and
3.	gravity to Gravity
4.	angle to Angle
c.	I have chosen to leave the prefixed t and f on all variable names as it is a single character and represents the domain of the variable as to whether it is t for the time domain or f for the frequency domain.
8.	The request is to keep only the columns which represent the mean and frequency of the measurements. In order to do this, the conditioned features data frame is subset using grep and assigned to a variable called columns_to_keep. In order to help create the code book columns_to_ keep is written to a file called df_columns_to_keep.txt.
9.	Next we read in the subject data into subject_train and assign it the column name tester.
10.	Now we read in the actual measurement variables in X_table.txt into x_train. Note that this data set is white space delimited. Sometime there is more than one space between variables. Therefore, we use read.table as it allows for any white space between variables if the separator is set to “”. 
11.	Subset the data into sub_x_train using the variable we created above columns_to_keep. Now we do not have any issues with duplicate column names. Note that if you do not remove the characters from the feature variables as we did above the R will treat some of the column names as duplicates.
12.	Now we check sub_x_train for NA values. I found that there are none in the dataset.
13.	Now, the data set data_train is created by column binding subject_train, y_train, and sub_x_train.  This dataset has 7352 observations and 86 variables.
14.	Next we read in the subject data into subject_test and assign it the column name tester.
15.	Now we read in the actual measurement variabes in X_test.txt into x_test. Note that this data set is white space delimited. Sometime there is more than one space between variables. Therefor we use read.table as it allows for any white space between variables if the separator is set to “”. 
16.	Subset the data into sub_x_test using the variable we created above columns_to_keep. Now we do not have any issues with duplicate column names. Note that if you do not remove the characters from the feature variables as we did above the R will treat some of the column names as duplicates.
17.	Now we check sub_x_test for NA values. I found that there are none in the dataset.
18.	Now, the data set data_test is created by column binding subject_test, y_test, and sub_x_test.  This dataset has 2947 observations and 86 variables.
19.	The next step is to append rbind data_test to data_train. Before verified  that:
a.	The dimensions of the data sets are the same.
b.	The tester is unique between the two files.  
20.	Now the two files are combined, so we want to get the mean of the columns. To do this use the dplyr package functions to create the tidy data set out_data:
a.	Use tbl_df to convert data to a data from table which is required for the dplyr tools. The output dataset is tbl_data. The table has 10,299 observations and 88 variables.
b.	Use group_by to group the table by tester and activity. The output dataset is g_data
c.	Use summarise_each to apply the mean to the non grouped columns. The output dataset is the final dataset out_data. The final dataset has 180 observations of 88 variables.
21.	Write out out_data to the tidy data set file tidy_data_set.txt.
The final data set has is of the form:

