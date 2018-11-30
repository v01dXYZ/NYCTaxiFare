#########################################
########### Permitted events ############
#########################################

rm(list=objects())
getwd()
setwd("/Users/thibault/Desktop/Cours\ Master\ 2/1er\ Semestre/Projet\ Data\ Mining")

Events <- read.csv(
  "Data/NYC_Permitted_Event_Information.csv",
  header=TRUE,
  #colClasses=c("key"="character","fare_amount"="numeric",
  #             "pickup_datetime"="POSIXct",
  #             "dropoff_longitude"="numeric","pickup_longitude"="numeric",
  #             "dropoff_latitude"="numeric","pickup_latitude"="numeric",
  #             "passenger_count"="integer"),
  #nrows=100000
)
