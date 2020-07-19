## Jayson Leek
## Coursera Getting and Cleaning Data Week 4
## July 2020
## install.packages("data.table")

## load packages
library(data.table)

## set working directory

setwd("C:/Users/jayso/Documents/getcleandata/getcleandata/week4")

## set the URL for the data as fileURL
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## download the data
download.file(fileURL, "./data/galaxy.zip")

## unzip the data
unzip("./data/galaxy.zip")

## set a file path to the data location
pathdata <- file.path("./", "UCI HAR Dataset")

## read the training set
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"), header = F)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"), header = F)
subtrain <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = F)

## read the test set
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"), header = F)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"), header = F)
subtest <- read.table(file.path(pathdata, "test", "subject_test.txt"), header = F)

## read the features names
featuresNames <- read.table(file.path(pathdata, "features.txt"), header = F)

## read the activity labels data
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"), header = F)

## assign features names to the training data
colnames(xtrain) <- featuresNames[, 2]
names(ytrain) <- "ActivityID"
names(subtrain) <- "Subject"

## assign features names to the testing data
colnames(xtest) <- featuresNames[, 2]
names(ytest) <- "ActivityID"
names(subtest) <- "Subject"

## assign activity labels values
colnames(activityLabels) <- c("ActivityID", "Activity")


## merge the data
mergetrain <- cbind(ytrain, subtrain, xtrain)
mergetest <- cbind(ytest, subtest, xtest)

## ----This is the solution to Part 1 - all data merged
AllData <- rbind(mergetrain, mergetest)


## create new datasets by extracting only the measurments for mean and standard deviation
colNames <- colnames(AllData)
mean_std <- (grepl("ActivityID", colNames) | 
               grepl("Subject", colNames) | 
               grepl("mean..", colNames) | 
               grepl("std..", colNames))

## subset just to means and standard deviations
## ----This is the solution to Part 2
Means_STD <- AllData[, mean_std == T]

## Solution to Part 3 and 4
## assign descriptive names to the activities in the data set
WithActivityNames <- merge(Means_STD, activityLabels, by = "ActivityID", all.x = T)

WithActivityNames$Subject <- as.factor(WithActivityNames$Subject)

WithActivityNames <- data.table(WithActivityNames)

TidySet <- aggregate(. ~Subject + Activity, WithActivityNames, mean)

write.table(TidySet, file = "Tidy.txt", row.names = F)