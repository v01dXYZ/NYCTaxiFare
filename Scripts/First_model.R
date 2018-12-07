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
  #nrows=1000000
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
test_aux <- train[train$key>=limit,]
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

train$fitted <- fc2$fitted
sqrt(mean((train$fitted-train$fare_amount)**2))
1 - (sum((train$fitted-train$fare_amount )^2)/sum((train$fare_amount-mean(train$fare_amount))^2))

test_aux$forecasts <- fc2$mean
sqrt(mean((test_aux$forecasts-test_aux$fare_amount)**2))
1 - (sum((test_aux$forecasts-test_aux$fare_amount )^2)/sum((test_aux$fare_amount-mean(test_aux$fare_amount))^2))

library(lubridate)
test$key <- floor_date(test$key, "hour")
newData <- left_join(test, test_aux[,c('key', 'forecasts')], by=c("key"))

sapply(newData, function(x) sum(is.na(x)))  # no missing values

attr(newData$forecasts, 'tsp') <- NULL  # issue with tsp attribute following the left_join
sqrt(mean(((newData$forecasts-newData$fare_amount)**2)))
1 - (sum((newData$forecasts-newData$fare_amount)^2)/sum((newData$fare_amount-mean(newData$fare_amount))^2))






