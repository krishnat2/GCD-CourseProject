# Code Book

This Code Book summarizes the Tidy Dataset fields produced by run_analysis.R

## Identifiers

* subjectID - The ID of the test subject
* activityLabel - The type of activity performed by the subject. Each subject (Person) performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).

## Measurements

The following measurements where agregated from the Raw Dataset. For Detailed Description of each of the following Measurements, please the README.txt file available in the DataSet folder UCI HAR Dataset. 

* timeBodyAccMeanX
* timeBodyAccMeanY
* timeBodyAccMeanZ
* timeBodyAccStdX
* timeBodyAccStdY
* timeBodyAccStdZ
* timeGravityAccMeanX
* timeGravityAccMeanY
* timeGravityAccMeanZ
* timeGravityAccStdX
* timeGravityAccStdY
* timeGravityAccStdZ
* timeBodyAccJerkMeanX
* timeBodyAccJerkMeanY
* timeBodyAccJerkMeanZ
* timeBodyAccJerkStdX
* timeBodyAccJerkStdY
* timeBodyAccJerkStdZ
* timeBodyGyroMeanX
* timeBodyGyroMeanY
* timeBodyGyroMeanZ
* timeBodyGyroStdX
* timeBodyGyroStdY
* timeBodyGyroStdZ
* timeBodyGyroJerkMeanX
* timeBodyGyroJerkMeanY
* timeBodyGyroJerkMeanZ
* timeBodyGyroJerkStdX
* timeBodyGyroJerkStdY
* timeBodyGyroJerkStdZ
* timeBodyAccMagnitudeMean
* timeBodyAccMagnitudeStd
* timeGravityAccMagnitudeMean
* timeGravityAccMagnitudeStd
* timeBodyAccJerkMagnitudeMean
* timeBodyAccJerkMagnitudeStd
* timeBodyGyroMagnitudeMean
* timeBodyGyroMagnitudeStd
* timeBodyGyroJerkMagnitudeMean
* timeBodyGyroJerkMagnitudeStd
* frequencyBodyAccMeanX
* frequencyBodyAccMeanY
* frequencyBodyAccMeanZ
* frequencyBodyAccStdX
* frequencyBodyAccStdY
* frequencyBodyAccStdZ
* frequencyBodyAccJerkMeanX
* frequencyBodyAccJerkMeanY
* frequencyBodyAccJerkMeanZ
* frequencyBodyAccJerkStdX
* frequencyBodyAccJerkStdY
* frequencyBodyAccJerkStdZ
* frequencyBodyGyroMeanX
* frequencyBodyGyroMeanY
* frequencyBodyGyroMeanZ
* frequencyBodyGyroStdX
* frequencyBodyGyroStdY
* frequencyBodyGyroStdZ
* frequencyBodyAccMagnitudeMean
* frequencyBodyAccMagnitudeStd
* frequencyBodyBodyAccJerkMagnitudeMean
* frequencyBodyBodyAccJerkMagnitudeStd
* frequencyBodyBodyGyroMagnitudeMean
* frequencyBodyBodyGyroMagnitudeStd
* frequencyBodyBodyGyroJerkMagnitudeMean
* frequencyBodyBodyGyroJerkMagnitudeStd

## Methodology

The run_analysis.R script takes the following steps to transform the Raw Dataset to Tidy Dataset.

1. Downloads the Raw Data Set in .ZIP Archive Format, using the url provided.
2. UnZIPs the archieve file using the utility function unzip()
3. Loads 'UCI HAR Dataset/features.txt' file to dtFeatures DataTable and extracts the Measurements with mean() and std() in the name. These Names are cleaned up, so they are descriptive. 
3.1 t and f are substituded with Time and Frequency. 
3.2 () are removed
3.3 Mag is substituded with Magnitude.
4. Loads 'UCI HAR Dataset/activity_labels.txt' file into dtActivityLabels and the columns are renamed activityID and activityLabel
5. The following Files in 'train' and 'test' folders are loaded into individual DataTables.
* subject_train.txt
* X_train.txt
* y_train.txt
* subject_test.txt
* X_test.txt
* y_text.txt
6. The subject, X and Y Train and Test datatables are  merged, using row bind.
7. The Merged subject dataset's column is renamed as subjectID
8. The Merged Y dataset's column is renamed as activityID.
9. Both these two datatables are column bind. Which is finally column binded with the X merged dataset, resulting in the single dataset, dtTrainingSet
10. subjectID and activityID from the dtTrainingSet datatable are set as Identifiers.
11. Using the dtFeatures datatable, we subset dtTrainingSet for only the columns of interest, i.e the columns with mean() and std().
12. The sub-setted datatable dt columns are assinged the Descriptive Column Names, from dtFeatures datatable. This gives us our Tidy Data Set.
13. This new datatable with Descriptive Column Names is joined with dtActivityLabels on the activityID columns, to get a dataTable with descriptive Activity Names and descriptive measurements. This is our Tidy Dataset.
14. The Project required that we extract a second Tidy DataSet, where each variable is aggregated for each activity and each subject. This is accumplished using the lapply() function and grouping the data by activityName and subjectID columns. The resultant dataset is saved to tidyData.txt file.