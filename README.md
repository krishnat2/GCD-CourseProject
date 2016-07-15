# Getting and Cleaning Data - Project:

The purpose of this repo, is for the submission of Course Project for Getting and Cleaning Data for Courser'a Data Science specilization.

## Steps to Reprodue this project:

1. Run the R Script file run_analysis.r using R-Studio

## Output of the Analysis:

Tidy Dataset file tidyData.txt

## Code Book

The Code Book for the Tidy Dataset can be found in CodeBook.md, along with the Methodology for run_analysis.R

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
	1. subject_train.txt
	2. X_train.txt
	3. y_train.txt
	4. subject_test.txt
	5. X_test.txt
	6. y_text.txt
6. The subject, X and Y Train and Test datatables are  merged, using row bind.
7. The Merged subject dataset's column is renamed as subjectID
8. The Merged Y dataset's column is renamed as activityID.
9. Both these two datatables are column bind. Which is finally column binded with the X merged dataset, resulting in the single dataset, dtTrainingSet
10. subjectID and activityID from the dtTrainingSet datatable are set as Identifiers.
11. Using the dtFeatures datatable, we subset dtTrainingSet for only the columns of interest, i.e the columns with mean() and std().
12. The sub-setted datatable dt columns are assinged the Descriptive Column Names, from dtFeatures datatable. This gives us our Tidy Data Set.
13. This new datatable with Descriptive Column Names is joined with dtActivityLabels on the activityID columns, to get a dataTable with descriptive Activity Names and descriptive measurements. This is our Tidy Dataset.
14. The Project required that we extract a second Tidy DataSet, where each variable is aggregated for each activity and each subject. This is accumplished using the lapply() function and grouping the data by activityName and subjectID columns. The resultant dataset is saved to tidyData.txt file.
