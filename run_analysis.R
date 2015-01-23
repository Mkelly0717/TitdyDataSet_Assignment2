########################################################
# Author: Michael A. Kelly Ph.D
# Class: Exploratory Analysis
# Assignment: 2 
# Creation Date: Jan 22nd 2015
########################################################
########################################################
#    Input data sets:
# 1) features.txt:
# 2) activity_labels.txt: Currently used to change factors
# 3) subject_train.txt:
# 4) x_train.txt:
# 5) y_train.txt:
# 6) subject_test.txt:
# 7) x_test.txt:
# 8) y_test.txt:
########################################################

rm(list=ls())   # uncomment if need to clear workspace
library(dplyr)
library(stringr)

#############################################################
# Get Enviroment Information for Information Purposes
# This can be used to determine the operating system to
# decide if one needs the curl method on download.file.
# I am not actually using it, because I do not have a mac
# to test it on.
#############################################################
env <- as.data.frame(Sys.getenv()
    
#############################################################
# Down load the file.
#############################################################
dataDir <- "./data"
fileName <- paste0(dataDir, "/Dataset.zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(dataDir)){dir.create(dataDir)}
if(!file.exists(fileName)){
    download.file(fileUrl,destfile=fileName, mode="wb")
   unzip(fileName)
}
################################################################
# Function f_is_unique(z): pass an atomic vector z. This func
#     will return TRUE if all elements of the vector are unique.
#     It will return false if they are not. It prints a message
#     to let you know the result.
################################################################
f_is_unique <- function(z){
    is_unique <-  TRUE
    n_recs    <- length(z)
    n_unique  <- length(unique(z))
    if(abs(n_recs - n_unique) > 0){is_unique <- FALSE}
    print(paste("All feature names are unique = "
             , is_unique
             , "."
             , sep=""
           )
     )
     return (is_unique)
}


################################################################
# Function f_remove_char(z): removes string from atomic vector z
################################################################
f_remove_char <- function(z,string){ gsub(string,"",z)}

################################################################
# Function f_remove_chars(z): pass an atomic vector z. This func
#     uses f_remove_char on the atomic vector z to remove
#     (, ) , whitespace, underscore, hyphen, leading 
#     and trailing spaces. And lowercase the strings.
################################################################
f_remove_chars <- function(z) {
    z <- f_remove_char(z,"\\(") 
    z <- f_remove_char(z,"\\)")
    z <- f_remove_char(z,",")
    z <- f_remove_char(z," +")
    z <- f_remove_char(z,"-")
    z <- tolower(z)
    z <- str_trim(z)
} 

################################################################
# Function f_unique_vector
################################################################
f_unique_vectors <- function(x,y) {
    is_has_duplicates <- FALSE
    combined_vectors <- c(unique(x), unique(y))
    if (sum(duplicated(combined_vectors)) > 0 ){
          is_has_duplicates <- TRUE
          print("Yes there are duplicates!")
    }
    else {print("No duplicates found!")
    }
    return(is_has_duplicates)
}


#################################################################
# Read in the activity labels and examine them. These will be   #
#  used to change the levels in the y_train and y_test datasets # 
#################################################################
activity_labels  <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep=" ", header=FALSE)
names(activity_labels) <- c("activity", "activity_type")
print("listing activty labels file for review =>")
print(head( activity_labels))

####################################################################
# Read in the activty file (y_train). Then change the factor names
#   in the dataset to the activity labels from the activity label file.
#####################################################################
y_train          <- read.csv ("./UCI HAR Dataset/train/y_train.txt", sep=" ", header=FALSE)
names(y_train) <- c("activity")
# Number of levels for factor is ==> nlevels(y_train$activity)
y_train$activity <- factor(y_train$activity, levels=activity_labels$activity, labels=activity_labels$activity_type)


####################################################################
# Read in the features and condition all of the feature names.        
#   Then  get a list of columns that we want to keep to be used later.    
#####################################################################
features         <- read.csv("./UCI HAR Dataset/features.txt", sep=" ", header=FALSE)
features$V2 <- f_remove_chars(features$V2)
columns_to_keep <- grep("[mM]ean|[sS]td", features$V2, value=TRUE)

####################################################################
# Read in the subject list (subject_train).
#####################################################################
subject_train    <- read.csv ("./UCI HAR Dataset/train/subject_train.txt", sep=" ", header=FALSE)
names(subject_train) <- c("testor")

####################################################################
# Read in the training data (x_train) Note using read.table because
#   the file is whitespace seperated( not always single spaced.
#    Initially use all column names to build the table then
#    use columns to keep to remove all non mean and std columns.
#####################################################################
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt"
                       , sep=""
                       , header=FALSE
                       , na.strings="NA"
                       ,col.names=features$V2
                     )

x_train <- x_train[,columns_to_keep]
   

###########################################################
# Column Bind the data sets (subject_train, y_train, and 
#    x_train together.
###########################################################
data_train <- cbind(subject_train, y_train, x_train[,1:length(x_train)])


####################################################################
# Read in the subject list (subject_test).
#####################################################################
subject_test    <- read.csv ("./UCI HAR Dataset/test/subject_test.txt", sep=" ", header=FALSE)
names(subject_test) <- c("testor")

####################################################################
# Read in the activty file (y_test). Then change the factor names
#   in the dataset to the activity labels from the activity label file.
#####################################################################
y_test          <- read.csv ("./UCI HAR Dataset/test/y_test.txt", sep=" ", header=FALSE)
names(y_test) <- c("activity")
# Number of levels for factor is ==> nlevels(y_test$activity)
y_test$activity <- factor(y_test$activity, levels=activity_labels$activity, labels=activity_labels$activity_type)

####################################################################
# Read in the testing data (x_test) Note using read.table because
#   the file is whitespace seperated( not always single spaced.
#    Initially use all column names to build the table then
#    use columns to keep to remove all non mean and std columns.
#####################################################################
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt"
                       , sep=""
                       , header=FALSE
                       , na.strings="NA"
                       ,col.names=features$V2
                     )
x_test <- x_test[,columns_to_keep]

###########################################################
# Column Bind the data sets (subject_test, y_test, and 
#    x_test together.
###########################################################
data_test <- cbind(subject_test, y_test, x_test[,1:length(x_test)])


############################################################
# Now prepare to combine the two datasets together.
# 1) All column names are the same as assigned above.
# 2) Verify that subjects numbers where not reused between training
#    and test datasets. If so they would need to be changed as they
#    are different test subjects in each data set.
#####################################################################
print ("testing subject data sets for duplicates ==> ")
  f_unique_vectors(subject_train$testor, subject_test$testor)
  

#######################################################################
# Ok no duplicates to fix now combine
#######################################################################
data <- rbind(data_train, data_test)

######################################################################
# Now let us use dplyr tools to group the data before calculating.
######################################################################
tbl_data <- tbl_df(data)

g_data <- group_by(tbl_data, testor, activity)

out_data <- summarise_each(g_data, funs(mean))

######################################################################
# Now write the output to a datafile
######################################################################
write.table(out_data
            ,file="tidy_data_set.txt"
            ,row.names=FALSE
            ,sep=","
            ,na="NA"
            ,dec="."
)
