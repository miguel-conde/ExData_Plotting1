data_directory <- "data_household_power_consumption"

if (!file.exists(data_directory)) {
    dir.create(data_directory)
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file<-file.path(data_directory, "household_power_consumption.txt")
temp_file<-sprintf("%s.zip", tempfile())

download.file(fileUrl, destfile = temp_file, method = "auto", mode="wb")
unzip(temp_file, exdir=data_directory)
dateDownloaded_data_housing <- date()
file.remove(temp_file)

powerConData <- read.table(file, sep=";", header = TRUE)

powerConData2Days<-powerConData[as.Date(powerConData$Date,"%d/%m/%Y")==as.Date("2007-02-01"),]
powerConData2Days<-rbind(powerConData2Days, powerConData[as.Date(powerConData$Date,"%d/%m/%Y")==as.Date("2007-02-02", row.names=FALSE),])

rm(powerConData)


times<-powerConData2Days$Time
dates<-as.Date(powerConData2Days$Date,"%d/%m/%Y")
dates_times <- paste(dates, times)
x<-strptime(dates_times, "%Y-%m-%d %H:%M:%S")


with(powerConData2Days, {
     plot(x,as.numeric(as.vector(Global_active_power)),type="n",
          xlab="",
          ylab="Global Active Power (kilowatts)")
    lines(x,as.numeric(as.vector(Global_active_power)),type="l")
})

with(powerConData2Days,
     lines(x,as.numeric(as.vector(Global_active_power)),type="l"))

dev.copy(png, file = "plot2.png") ## Copy my plot to a PNG file
dev.off()
