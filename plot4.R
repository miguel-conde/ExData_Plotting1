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

plot.new()
par(mfrow = c(2,2))

with(powerConData2Days, {
    # Same as plot2 in (1,1)
    plot(x,as.numeric(as.vector(Global_active_power)),type="l",
         xlab="",
         ylab="Global Active Power",
         cex.lab=0.7,
         cex.axis=0.7)

    # Voltage plot in (1,2)
    plot(x,as.numeric(as.vector(Voltage)),type="l",
         xlab="",
         ylab="Voltage",
         cex.lab=0.7,
         cex.axis=0.7)

    # Same as plot3 in (2,1)
    plot(x,as.numeric(as.vector(Sub_metering_1)),type="l",
         xlab="",
         ylab="Energy sub metering",
         col="azure4",
         cex.lab=0.7,
         cex.axis=0.7)
    lines(x,as.numeric(as.vector(Sub_metering_2)),
          type="l",
          col="red")
    lines(x,as.numeric(as.vector(Sub_metering_3)),
          type="l", 
          col="blue")
    legend("topright", lty = 1, 
           col = c("azure4", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           cex=0.7)

    # Global_reactive_power in (2,2)
    plot(x,as.numeric(as.vector(Global_reactive_power)),type="l",
         xlab="",
         ylab="Global_reactive_power",
         cex.lab=0.7,
         cex.axis=0.7)
})

dev.copy(png, file = "plot4.png") ## Copy my plot to a PNG file
dev.off()

