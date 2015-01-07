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
powerConData2Days<-rbind(powerConData2Days, powerConData[as.Date(powerConData$Date,"%d/%m/%Y")==as.Date("2007-02-02", row.names=FALSE),])

# Free big dataframe
rm(powerConData)

# Load requires dates and times (some messy stuff here with formats)
# for graphic x-axis
times<-powerConData2Days$Time
dates<-as.Date(powerConData2Days$Date,"%d/%m/%Y")
dates_times <- paste(dates, times)
x<-strptime(dates_times, "%Y-%m-%d %H:%M:%S")

# Clear device
plot.new()

# Draw linear graphic
with(powerConData2Days, {
     plot(x,as.numeric(as.vector(Global_active_power)),type="l",
          xlab="",
          ylab="Global Active Power (kilowatts)")
})

## Copy my plot to a PNG file
dev.copy(png, file = "plot2.png") 
dev.off()
