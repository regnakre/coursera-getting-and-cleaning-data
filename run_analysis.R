setwd("C:/Users/erkaner/OneDrive/Coursera-data-cleaning/final-project/UCI HAR Dataset/")

## 1: Reading all related data from the txt files
test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
test.data <- read.table("test/X_test.txt")
train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
train.data <- read.table("train/X_train.txt")

# combine everything: columns and rows
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))

## 1: Get the features from the features.txt file
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# filter features and include only mean and standard deviation related
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# use the features.mean.std to selected the desired features from the data
# +2 is added to skip the first two columns which are subjects and labels
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

names(data.mean.std)


## 3: Get the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

## 4 refine the columnnames
good.colnames <- c("subject", "label", features.mean.std$V2)
good.colnames <- tolower(good.colnames)
colnames(data.mean.std) <- good.colnames

## 5 find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

# write the data to a txt file to upload to github and coursera
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)

