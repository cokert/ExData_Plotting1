library(readr)
library(lubridate)

#read file
dat<-read_delim("household_power_consumption.txt", delim =";", col_types = "ccnnnnnnn", na="?" )

#fix column names
cn = names(dat)
cn = tolower(cn)        #lower case
cn = gsub("_", "", cn)  #remove underscore
cn[1]="mydate"          #rename "date" to "mydate" because of conflict with base::date
names(dat) = cn

#dates in this file are in d/m/yyyy format
dat<-dat %>% filter(mydate=="1/2/2007" | mydate=="2/2/2007")

#create datetime column using lubridate function
dat$datetime<-dmy_hms(paste(dat$mydate,dat$time))

png(file="plot4.png")

#set number of graphs
par(mfrow=c(2,2))

#set transparent background
par(bg=NA)

#global active power
plot(dat$datetime, dat$globalactivepower, ylab="Global Active Power", type="l", xlab="")

#voltage
plot(dat$datetime, dat$voltage, ylab="Voltage", xlab="datetime", type="l")

#energy sub metering
plot(dat$datetime, dat$submetering1, type="n", ylab="Energy sub metering", xlab="")
points(dat$datetime, dat$submetering1, type="l", col="black")
points(dat$datetime, dat$submetering2, type="l", col="red")
points(dat$datetime, dat$submetering3, type="l", col="blue")
legend("topright", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n", lty=1)

#global reactive power
plot(dat$datetime, dat$globalreactivepower, ylab="Global_reactive_power", xlab="datetime", type="l")

#close device/file
dev.off()