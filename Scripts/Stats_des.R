#########################################
######### Exploratory analysis ##########
#########################################

rm(list=objects())
getwd()
setwd("/Users/thibault/Desktop/Cours\ Master\ 2/1er\ Semestre/Projet\ Data\ Mining")

library(padr)
library(plyr)
library(dplyr)

library(plotly)
Sys.setenv("plotly_username"="ThibaultR7")
Sys.setenv("plotly_api_key"="OQTkqSvSm8GdBkldp1jY")
Sys.setenv('MAPBOX_TOKEN' = 'pk.eyJ1IjoidGhpYmF1bHRyIiwiYSI6ImNqb3llNWJubjBhbTIzcXA1MWtucWw5b2EifQ.NvXNEjdCyHl2-Au3CnhPvQ')

################################# Data file creation #################################
library(data.table)
Data <- fread(
  file="Data/train.csv",
  nrows = 3000000
)

# summary
head(Data, n = 5)
tail(Data, n= 5)
summary(Data)
nrow(Data)

Data$pickup_datetime=as.POSIXct(Data$pickup_datetime, format="%Y-%m-%d %H:%M:%S", tz = 'GMT')

# Remove some incoherent data
Data <- Data[!(Data$fare_amount<0 |
               Data$pickup_longitude<(-74.259090) | Data$pickup_longitude>(-73.700272) |
               Data$pickup_latitude<40.477399  | Data$pickup_latitude>40.917577 |
               Data$dropoff_longitude<(-74.259090) | Data$dropoff_longitude>(-73.700272) |
               Data$dropoff_latitude<40.477399  | Data$dropoff_latitude>40.917577 |
               Data$passenger_count>10),]
nrow(Data)

# Expand datetime features
library(lubridate)
Data$year <- year(Data$pickup_datetime)
Data$month <- month(Data$pickup_datetime)
Data$hour <- hour(Data$pickup_datetime)
Data$weekday_name <- weekdays(Data$pickup_datetime)
Data$weekday <- as.POSIXlt(Data$pickup_datetime)$wday
Data$weekday <- Data$weekday + 7 * (Data$weekday<1) - 1

head(Data)
summary(Data)

# Missing values
sapply(Data, function(x) sum(is.na(x)))  # no missing values

################################### Prelim dataviz ###################################
# Location
p <- plot_ly(alpha = 0.5) %>%
  add_histogram(x = ~Data$pickup_longitude, name='pickup') %>%
  add_histogram(x = ~Data$dropoff_longitude, name='dropoff') %>%
  layout(barmode = "overlay", title='Longitude histograms', xaxis=list(title='Longitude'))
p

p <- plot_ly(alpha = 0.5) %>%
  add_histogram(x = ~Data$pickup_latitude, name='pickup') %>%
  add_histogram(x = ~Data$dropoff_latitude, name='dropoff') %>%
  layout(barmode = "overlay", title='Latitude histograms', xaxis=list(title='Latitude'))
p

# fare histograms
p <- plot_ly(x = ~Data$fare_amount, type = "histogram", nbinsx=150) %>%
  layout(title='Fare histogram', xaxis=list(title='Fare'))
p

# boxplots
p <- plot_ly(y = Data$passenger_count, type = "box", name = '') %>%
  layout(title='Passenger count boxplot', yaxis=list(title='Count'))
p

p <- plot_ly(y = Data$fare_amount, type = "box", name = '') %>%
  layout(title='Fare boxplot', yaxis=list(title='Fare'))
p

###################################### Geoplots ######################################
# pickup data
p <- Data[1:30000] %>%
  plot_mapbox(lat = ~pickup_latitude, lon = ~pickup_longitude,
              marker = list(size=4, color = 'gold', opacity = 0.8),
              type = 'scattermapbox', width=900, height=600,
              mode= 'markers') %>%
  layout(title = 'Pickup locations in New York',
         mapbox = list(
           bearing=10,
           pitch=60,
           zoom=13,
           center= list(lat=40.721319, lon=-73.987130),
           style= "mapbox://styles/shaz13/cjiog1iqa1vkd2soeu5eocy4i"
           ),
         autosize=FALSE
         )
p

# Drop off data
p <- Data[1:10000] %>%
  plot_mapbox(lat = ~dropoff_latitude, lon = ~dropoff_longitude,
              marker = list(size=4, color = 'cyan', opacity = 0.8),
              type = 'scattermapbox', width=900, height=600,
              mode= 'markers') %>%
  layout(title = 'Pickup locations in New York',
         mapbox = list(
           bearing=10,
           pitch=60,
           zoom=13,
           center= list(lat=40.721319, lon=-73.987130),
           style= "mapbox://styles/thibaultr/cjoyogk4401cc2qljd2syhhql"
         ),
         autosize=FALSE
  )
p


# Business days
Bus_Data <- Data[(Data$weekday<=5),]
Bus_Data$day_moment <- ifelse((Bus_Data$hour < 10 & Bus_Data$hour > 5), "Early_Business", NA)
Bus_Data <- within(Bus_Data, day_moment <- ifelse(is.na(day_moment),
                                                  ifelse(Bus_Data$hour > 18, "Late_Business", NA),
                                                  day_moment))
head(Bus_Data)

p <- Bus_Data[complete.cases(Bus_Data), ][1:10000,] %>%
  plot_mapbox(lat = ~pickup_latitude, lon = ~pickup_longitude, split = ~day_moment, hoverinfo='name',
              marker = list(size=4, opacity = 0.8),
              type = 'scattermapbox', width=900, height=600,
              mode= 'markers') %>%
  layout(title = 'Pickup locations in New York - Business',
         font = list(color='white'),
         autosize=FALSE,
         plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
         mapbox = list(
           bearing=10,
           pitch=60,
           zoom=11,
           center= list(lat=40.721319, lon=-73.987130),
           style = 'mapbox://styles/thibaultr/cjoyogk4401cc2qljd2syhhql'
           ),
         legend = list(orientation = 'h',
                       font = list(size = 8)),
         margin = list(l = 25, r = 25,
                       b = 25, t = 25,
                       pad = 2))
p

# Weekend
WD_Data <- Data[(Data$weekday>5),]
WD_Data$day_moment <- ifelse((WD_Data$hour < 10 & WD_Data$hour > 5), "Early_WD", NA)
WD_Data <- within(WD_Data, day_moment <- ifelse(is.na(day_moment),
                                                  ifelse(WD_Data$hour > 18, "Late_WD", NA),
                                                  day_moment))
head(WD_Data)

p <- WD_Data[complete.cases(WD_Data), ][1:10000,] %>%
  plot_mapbox(lat = ~pickup_latitude, lon = ~pickup_longitude, split = ~day_moment, hoverinfo='name',
              marker = list(size=4, opacity = 0.8),
              type = 'scattermapbox', width=900, height=600,
              mode= 'markers') %>%
  layout(title = 'Pickup locations in New York - Weekend',
         font = list(color='white'),
         autosize=FALSE,
         plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
         mapbox = list(
           bearing=10,
           pitch=60,
           zoom=11,
           center= list(lat=40.721319, lon=-73.987130),
           style = 'mapbox://styles/thibaultr/cjoyogk4401cc2qljd2syhhql'
         ),
         legend = list(orientation = 'h',
                       font = list(size = 8)),
         margin = list(l = 25, r = 25,
                       b = 25, t = 25,
                       pad = 2))
p

# Highfare locations

High_fares <- Data[(Data$fare_amount > mean(Data$fare_amount) + 3*sqrt(var(Data$fare_amount))),]
High_fares <- High_fares[High_fares$weekday==0,]
nrow(High_fares)

p <- plot_mapbox(mode = 'scattermapbox') %>%
  add_markers(
    data = High_fares, x = ~pickup_longitude, y = ~pickup_latitude, text=~pickup_datetime, color=I("red"),
    size = ~fare_amount, hoverinfo = "text", alpha = 0.5) %>%
  add_markers(
    data = High_fares, x = ~dropoff_longitude, y = ~dropoff_latitude, text=~pickup_datetime, color=I("cyan"),
    size = ~fare_amount, hoverinfo = "text", alpha = 0.5) %>%
  add_segments(
    data = High_fares,
    x = ~pickup_longitude, xend = ~dropoff_longitude,
    y = ~pickup_latitude, yend = ~dropoff_latitude,
    alpha = 0.3, size = I(1), hoverinfo = "none", opacity = 0.2,
    color=I("red")) %>%
  layout(
    title = 'High fares journeys',
    plot_bgcolor = '#191A1A', paper_bgcolor = '#191A1A',
    mapbox = list(
      bearing=10,
      pitch=60,
      zoom=11,
      center= list(lat = median(High_fares$pickup_latitude),
                   lon = median(High_fares$pickup_longitude)),
      style= "mapbox://styles/shaz13/cjiog1iqa1vkd2soeu5eocy4i"
    ),
    margin = list(l = 0, r = 0,
                  b = 0, t = 0,
                  pad = 0),
    showlegend=FALSE)
p
