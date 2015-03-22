#  Getting and Cleaning Data - Johns Hopkins Bloomberg School of Public Health and Coursera
*The run_analysis script for the Human Activity Recognition Using Smartphones Data Set 
*By: Herwin Pozzobon Silva
*Date: 2015-03-21
*Important remarks: it is assumed that all the packages are installed and available
*I organized my script in six steps
* The first step: getting the file and uncompressing it, with de following activities:
*        clean the environment
*        create andd position on the special directory "Run_Analysis" to better organize the work
*        download the zip file "Human Activity Recognition Using Smartphones Data Set"
*        uncompress the zip file
* The second step: reading and merging the ".txt" files and assembling the final data set, with de following activities:
*        bind the training data files
*        bind the test data files
*        assembling the final data table
* The third step: getting only the data needed for future analysis: mean and std deviation for each measure, with de following activities:
*        selection of the features needed
*        filter only features that has mean or std in the name
* The fourth step: naming the activities in the data set, with de following activities:
*        read and set the activities name
* The fifth step: naming/labeling the data set columns
* The sixth step: generating the final tidy data set
