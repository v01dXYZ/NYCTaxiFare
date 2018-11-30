#########################################
######## First model - benchmark ########
#########################################

rm(list=objects())
getwd()
setwd("/Users/thibault/Desktop/Cours\ Master\ 2/1er\ Semestre/Projet\ Data\ Mining")

library(padr)
library(plyr)
library(dplyr)

####### Data handling #######

# creating the file
library(data.table)
Data <- fread(
  file="Data/train.csv",
)

# Resampling
Data <- Data[,c("key","fare_amount")]
Data$key=as.POSIXct(Data$key, format="%Y-%m-%d %H:%M:%S")  # char to datetime
head(Data)

train <- Data %>% thicken("hour") %>% group_by(key_hour) %>% summarise(median(fare_amount))  # resampling
train <- plyr::rename(train,c("key_hour"="key","median(fare_amount)"="fare_amount"))

head(train)
tail(train)

limit <- as.POSIXct("2015-01-01 00:00:00", format="%Y-%m-%d %H:%M:%S")

h <- nrow(train[train$key>=limit,])
train <- train[train$key<limit,]
test <- Data[Data$key>=limit,]

# Fare plot
par(mfrow=c(1,1))
plot(train$key, train$fare_amount, ylab = "Fare", xlab = "Date", type='l', col = 634, fg =139, bg = 139)

# Autocorrelation plot
acf(train$fare_amount, lag.max = 500, main="Autocorrelation")


####### Data handling #######

# Models
library(forecast)

fare_ts <- ts(train[,2], freq=24, start=0)

# tbats
faretbats <- tbats(fare_ts, num.cores = NULL)
fc2 <- forecast(faretbats, h=h)
plot(fc2)


