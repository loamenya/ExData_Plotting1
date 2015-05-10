#read the whole dataset
download_url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("household_power_consumption.txt")){
    download.file(download_url, destfile ="household_power_consumption.zip" ,mode="wb")
    unzip("household_power_consumption.zip")
} 

data <- read.csv2(file = "household_power_consumption.txt",na.strings="?")
message(sprintf("Read %s rows", nrow(data)))

message(sprintf("Date column is of class: %s", class(data$Date)))
#convert the Date from factor to date
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
message(sprintf("Converted Date column to class: %s", class(data$Date)))


#filter the dataset to dates
data_subset <- subset(data, Date >= '2007-02-01' & Date <= '2007-02-02')
message(sprintf("Filtered data by date to %s rows", nrow(data_subset)))

#create a date and time column
data_subset$Date_Time <- paste(data_subset$Date,data_subset$Time)
message(sprintf("Created Date_Time column of class: %s", class(data_subset$Date_Time)))

#convert Date_Time to Posixlt
data_subset$Date_Time <- strptime(data_subset$Date_Time, format="%Y-%m-%d %H:%M:%S")
message(sprintf("Converted Date_Time column to class: %s", class(data_subset$Date_Time)))

message(sprintf("Global_active_power column is of class: %s", class(data$Global_active_power)))
data_subset$Global_active_power <- suppressWarnings(as.double(data_subset$Global_active_power))
message(sprintf("Converted Global_active_power column to class: %s", class(data_subset$Global_active_power)))

#exclude missing data
data_subset <- subset(data_subset,!is.na(Global_active_power))
#plot to png device
png(filename="plot1.png",width = 504,height = 504,units ="px", bg="white")
hist(data_subset$Global_active_power/1000, xlab="Global Active Power(kilowatts)",main="Global Active Power",col="orangered")
dev.off()
