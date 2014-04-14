setwd("D:\\John\\Documents\\Data-Science\\3 - Data")

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'

download.file(url= fileUrl, destfile="idaho.csv")

idahoData <- read.table("idaho.csv", sep = ",", header=TRUE)
head(idahoData)

# find count of homes worth 1M+ (id = 24)
tmp <- idahoData[["VAL"]] == 24 & !is.na(idahoData[["VAL"]])
sum(tmp)

gasFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

download.file(url=gasFile, destfile="gas.xlsx")

#install.packages("xlsx")
library(xlsx)

colIndex <- 7:15
rowIndex <- 18:23

dat <- read.xlsx("gas2.xlsx", colIndex=colIndex, rowIndex=rowIndex, sheetIndex=1)

sum(dat$Zip*dat$Ext,na.rm=T) 

restaurantFile = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

download.file(restaurantFile, destfile="restaurants.xml")
install.packages("XML")
library(XML)
doc <- xmlTreeParse("restaurants.xml", useInternal=TRUE)
rootNode <- xmlRoot(doc)
zipcodes <- xpathSApply(rootNode, "//zipcode", xmlValue)

tmp <- zipcodes == "21231"
sum(tmp)


surveyUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"

download.file(surveyUrl, destfile="getdata-data-ss06pid.csv")
#This is the WRONG way to open the file!
DT <- read.table("getdata-data-ss06pid.csv", header=TRUE, sep=",")

#system.time(mean(DT$pwgtp15,by=DT$SEX))

system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
#system.time(DT[,mean(pwgtp15),by=SEX])
#system.time({rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
system.time(tapply(DT$pwgtp15,DT$SEX,mean))

# Most of the code below here is adapted/copied from what the course TAs have posted in the discussion area for Quiz 1

trialsize <- 100;
t1 <- proc.time();
for (i in 1:trialsize){
  mean(DT[DT$SEX==1,]$pwgtp15); 
  mean(DT[DT$SEX==2,]$pwgtp15);
}
t2 <- proc.time();
t2 - t1;

t1 <- proc.time();
for (i in 1:trialsize){
  sapply(split(DT$pwgtp15,DT$SEX),mean);
}
t2 <- proc.time();
t2 - t1;

t1 <- proc.time();
for (i in 1:trialsize){
  tapply(DT$pwgtp15,DT$SEX,mean);
}
t2 <- proc.time();
t2 - t1;

#install.packages("microbenchmark")
#install.packages("ggplot2")
library(microbenchmark)
library(ggplot2)

bench <- microbenchmark({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)}, sapply(split(DT$pwgtp15,DT$SEX),mean), tapply(DT$pwgtp15,DT$SEX,mean), DT[,mean(pwgtp15),by=SEX])
autoplot(bench)




#library(data.table)
DT <- fread("getdata-data-ss06pid.csv")
trialsize=200
exp1u <- numeric(trialsize)
exp2u <- numeric(trialsize)
exp3u <- numeric(trialsize)

for (i in 1:trialsize){
  e1 <- system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
  e2 <- system.time(tapply(DT$pwgtp15,DT$SEX,mean))
  e3 <- system.time(DT[,mean(pwgtp15),by=SEX])
  exp1u[i] <- e1[1]
  exp2u[i]  <- e2[1]
  exp3u[i]  <- e3[1]
}
print("sapply")
print(mean(exp1u))
print("tapply")
print(mean(exp2u))
print("data.table")
print(mean(exp3u))
