# Preparing a directory where unzip downloaded file
data_directory <- "data_household_power_consumption"

if (!file.exists(data_directory)) {
    dir.create(data_directory)
}

# Build url, file name and temporary zipped file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file<-file.path(data_directory, "household_power_consumption.txt")
temp_file<-sprintf("%s.zip", tempfile())

# Download zipped file to temporary file...
download.file(fileUrl, destfile = temp_file, method = "auto", mode="wb")
# ...unzip it...
unzip(temp_file, exdir=data_directory)
# ...record date...
dateDownloaded_data_housing <- date()
#... and get rid of temporary file.
file.remove(temp_file)

# Load file into a big dataframe
powerConData <- read.table(file, sep=";", header = TRUE)

# Keep just two indicated days data
powerConData2Days<-powerConData[as.Date(powerConData$Date,"%d/%m/%Y")==as.Date("2007-02-01"),]
powerConData2Days<-rbind(powerConData2Days, powerConData[as.Date(powerConData$Date,"%d/%m/%Y")==as.Date("2007-02-02"),])

# Free big dataframe
rm(powerConData)

# Draw histogram
hist(as.numeric(as.vector(powerConData2Days$Global_active_power)),
     main = "Global Active Power", col="red", 
     xlab="Global Active Power (kilowatts)")

## Copy my plot to a PNG file
dev.copy(png, file = "plot1.png") ## Copy my plot to a PNG file
dev.off()
