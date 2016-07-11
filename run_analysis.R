# Load Library Data Table
library(data.table)

# Section 1: Download and Unzip the Source Data

#Download the Files
urlForZIPFile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# The File needs to be downloaded to a path, for simplicity, 
# lets just download it to the current Working Directory Folder.
# The file is begin saved as dataset.zip
download.file(urlForZIPFile,'dataset.zip', method = 'curl')

# unzip to the current working directory. The data would be extracted to the UCI HAR Dataset folder
unzip('dataset.zip', exdir = '.', unzip = 'internal', overwrite = TRUE)


# Section 2: Load Data into Data Table, update the column names with Descriptive Names
# and merge Data sets.

# Load features.txt
dtFeatures <- data.table(read.csv('./UCI HAR Dataset/features.txt', sep='', header = FALSE))
# Rename columns with descriptive names
setnames(dtFeatures, names(dtFeatures), c('featureID', 'featureName'))
# Subset dtFeatures for all fields that match mean() and std()
dtFeatures <- dtFeatures[grep('.*mean\\(\\).*|.*std\\(\\).*', dtFeatures$featureName)]

# Change to descriptive Names
dtFeatures$featureName <- gsub('-mean', 'Mean', dtFeatures$featureName)
dtFeatures$featureName <- gsub('-std', 'Std', dtFeatures$featureName)
dtFeatures$featureName <- gsub('[-()]', '', dtFeatures$featureName)
dtFeatures$featureName <- gsub('^t', 'time', dtFeatures$featureName)
dtFeatures$featureName <- gsub('^f', 'frequency', dtFeatures$featureName)
dtFeatures$featureName <- gsub('Mag', 'Magnitude', dtFeatures$featureName)

# Load Activity Names from activity_labels.txt file
dtActivityLabels <- data.table(read.csv('./UCI HAR Dataset/activity_labels.txt', sep='', header = FALSE))
# Rename the columns with descriptive names
setnames(dtActivityLabels, names(dtActivityLabels), c('activityID', 'activityLabel'))

# Load train/subject_train.txt, train/y_train.txt and train/X_train.txt
dtTrainSubject <- data.table(read.csv('./UCI HAR Dataset/train/subject_train.txt', header = FALSE))
dtTrainTrainingLabels <- data.table(read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE))
dtTrainTrainingSet <- data.table(read.csv('./UCI HAR Dataset/train/X_train.txt', sep='', header = FALSE))

# Load test/subject_train.txt, test/y_train.txt and test/X_train.txt
dtTestSubject <- data.table(read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE))
dtTestTrainingLabels <- data.table(read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE))
dtTestTrainingSet <- data.table(read.csv('./UCI HAR Dataset/test/X_test.txt', sep='', header = FALSE))

# Merge Test and Train Datasets
dtSubject <- rbind(dtTrainSubject, dtTestSubject)
dtTrainingLabels <- rbind(dtTrainTrainingLabels, dtTestTrainingLabels)
dtTrainingSet <- rbind(dtTrainTrainingSet, dtTestTrainingSet)

#Rename column V1 in dtSubject to a descriptive name
setnames(dtSubject, 'V1', 'subjectID')

# Rename column V1 in dtTrainingLabels to a descriptive
setnames(dtTrainingLabels, 'V1', 'activityID')

# Merge dtTrainingLabels and dtSubject
dtSubject <- cbind(dtSubject, dtTrainingLabels)

# Merge the dtSubject table table to the TrainingSet data table
dtTrainingSet <- cbind(dtSubject, dtTrainingSet)

# Create a key for dtTrainingSet table
setkey(dtTrainingSet, subjectID, activityID)

# Get list of Columns that we need to look up, the filtered dtFeatured Columns from dtTrainingSet
# When dtTrainingSet was loaded, each column was labeled V1, V2, V3... so by contcatinating
# V with the featuredID column from dtFeatures, we determine the columns we need from dtTrainingSet
columnsOfInterest <- c(key(dtTrainingSet), paste0('V', dtFeatures$featureID))

# Now subseting dtTrainingSet for our Columns of Interest, i.e. Mean and Std
# Since we created a key for dtTrainingSet, columns - subject and activityLabel 
# would be selected by default
dt <- subset(dtTrainingSet,,columnsOfInterest)

# update the column names for dt, with the descriptive names from dtFeatures table
colnames(dt)[3:ncol(dt)] <- as.vector(dtFeatures$featureName)

# Merge Activity Name to the datatable. This gives us the final data set with descriptive names.
dt <- merge(dtActivityLabels, dt, by = 'activityID', all.x = TRUE)


# Section 3: Independent Tindy Data set with the average of each variable for each activity and each subject

# Now to extract the second data set, we use lapply to determine the mean of all the 
# columns from 3 onwards, and group by activityLabel and subjectID columns.
tidydt <- dt[, lapply(.SD, mean), by='activityLabel,subjectID', .SDcol = names(dt)[4:ncol(dt)]]

write.table(tidydt, './tidyData.txt', row.names = FALSE, sep=',')