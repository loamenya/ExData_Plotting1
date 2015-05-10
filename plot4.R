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

message(sprintf("Voltage column is of class: %s", class(data$Voltage)))
data_subset$Voltage <- suppressWarnings(as.double(data_subset$Voltage))
message(sprintf("Converted Voltage column to class: %s", class(data_subset$Voltage)))

#exclude missing data
data_subset <- subset(data_subset,!is.na(Global_active_power))
data_subset$Global_active_power <- data_subset$Global_active_power/1000
data_subset$Voltage <- data_subset$Voltage/10
graph1_data<- data_subset[,c("Date_Time","Global_active_power")]
graph2_data<- data_subset[,c("Date_Time","Voltage")]
graph3_data1<- data_subset[,c("Date_Time","Sub_metering_1")]
graph3_data2<- data_subset[,c("Date_Time","Sub_metering_2")]
graph3_data3<- data_subset[,c("Date_Time","Sub_metering_3")]
graph4_data<- data_subset[,c("Date_Time","Global_reactive_power")]


#plot to png device
png(filename="plot4.png",width = 504,height = 504,units ="px", bg="white")
old.par <- par(mfrow=c(2,2),mar=c(7,5,2,2),cex=0.5)

#first graph
plot(graph1_data,pch =".",type ="l",ylab="Global Active Power", xlab="" )

#second graph
plot(graph2_data,pch =".",type ="l", xlab="datetime")

#third graph
plot(graph3_data1,pch =".",type ="l",ylab="Energy sub metering", xlab="" )
lines(graph3_data2,pch =".",type ="l",col="red")
lines(graph3_data3,pch =".",type ="l",col="blue")
legend("topright", lty = c(1, 1), lwd = c(1, 1, 1), col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#fourth graph
plot(graph4_data,pch =".",type ="l", xlab="datetime" )

par(old.par)
dev.off()
