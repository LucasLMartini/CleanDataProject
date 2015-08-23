# ATTENTION: LaF && ffbase packages required!!
library(LaF); library(ffbase)

# Helper function that, using the labels in activity_labels.txt, returns
# the human readable activty string for numeric activity ID "x"
replaceActivity <- function(x) {
    activityLabels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                       "SITTING","STANDING","LAYING")
    return(activityLabels[x])
}

# This function makes a dataFrame from the path passed as parameter,
# following the project's guidelines
makeDataFrame <- function(path) {
    #Start by reading the subjects
    filename = paste("subject_",cwd,".txt",sep = "")
    filename = file.path(path,filename)
    
    lines = readLines(filename)
    
    df = data.frame(subject = lines)
    
    # Now read the activities and replace them with human-readable names:
    filename = paste("y_",cwd,".txt",sep = "")
    filename = file.path(path,filename)
    lines = readLines(filename)
    df$activity = as.numeric(lines)
    df$activity = sapply(df$activity,replaceActivity)
    
    # Now we read the ACTUAL data from the experiment, keeping only the observations for
    # means and std deviations
    columnNames <<- readLines(file.path("UCI HAR Dataset","features.txt"))
    columnNames <<- make.names(columnNames)
    filename = paste("X_",cwd,".txt",sep = "")
    filename = file.path(path,filename)
    xData = laf_open_fwf(filename, column_widths = rep(16,561), column_types = rep("numeric",561),column_names = columnNames)
    xData <- laf_to_ffdf(xData)
    xData <- as.data.frame(xData)
    
    relevantNames <<- c(grep(glob2rx("*std*"),columnNames, value = T), grep(glob2rx("*mean*"),columnNames, value = T))
    
    xData = xData[, relevantNames]
    df = cbind(df,xData)
}

# Configure the folder options:
cwd = "test";
path = file.path("UCI HAR Dataset", cwd)
data <- makeDataFrame(path)
cwd = "train";
path = file.path("UCI HAR Dataset", cwd)
data <- rbind(data,makeDataFrame(path))

data$activity <- as.factor(data$activity)

# Generate the averages for each subject/activity pair:
splitData <- split(data,data$subject)

data.avgs = NULL;

for(l in splitData) {
    actSplit <- split(l,l$activity)
    subject <- l[[1]][1]
    for(l2 in actSplit) {
        activity <- l2$activity[1]
        l2$subject <- NULL; l2$activity <- NULL;
        means <- colMeans(l2)
        if (is.null(data.avgs)) {
            data.avgs = data.frame(subject = subject, activity = activity)
            data.avgs <- cbind(data.avgs,as.list(means))
        } else {
            tempAvgs = data.frame(subject = subject, activity = activity)
            tempAvgs = cbind(tempAvgs,as.list(means))
            data.avgs = rbind(data.avgs, tempAvgs)
        }
    }
}