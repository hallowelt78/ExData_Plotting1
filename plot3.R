##
library(lubridate)
library(dplyr)
Sys.setlocale("LC_TIME","en_US")


## load data
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
localfile <- "household_power_consumption.zip"
datapath <- "data"

if (!file.exists(datapath)) dir.create(datapath)

if (!file.exists(file.path(datapath,localfile))) {
  download.file(url, file.path(datapath,localfile), "curl")
  unzip (file.path(datapath,localfile), exdir=datapath)
}



data <- read.csv(file.path(datapath,"household_power_consumption.txt"), 
                 sep = ";", 
                 colClasses=c('character', 'character', rep('numeric', 7)), 
                 na.strings = '?')

data <- mutate (data, 
                timestamp = dmy_hms( paste(data$Date, data$Time, sep=' ')), 
                .before ="Date")


# generate data subset

mysubset <- subset(data, timestamp >= as.Date("2007-02-01") & timestamp < as.Date("2007-02-03"))


# generating plot


## plot 3
plotImage <- "plot3.png"


if (is.character(plotImage)) png(file = plotImage, width=480, height=480)

with(mysubset,plot(Sub_metering_1~timestamp,
                   ylab ="Energy sub metering",xlab ="", type="l")
     )
with(mysubset,lines(Sub_metering_2~timestamp, col = "red"))
with(mysubset,lines(Sub_metering_3~timestamp,col = "blue"))
legend(x='topright', legend=c('sub_metering_1', 'sub_metering_2', 'sub_metering_3'), 
       horiz = FALSE, 
       col=c('black', 'red', 'blue'), 
       lty=c(1,1,1))

if (is.character(plotImage)) dev.off()