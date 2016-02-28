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

#open device/file
png(file="plot2.png")

#set transparent background
par(bg=NA)

#generate plot
plot(dat$datetime, dat$globalactivepower, ylab="Global Active Power (kilowats)", type="l", xlab="")

#close device/file
dev.off()