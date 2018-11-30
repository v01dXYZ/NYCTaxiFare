library(tidyverse)
library(lubridate)
library(magrittr)

data0 <- read_csv("../Data/train.csv", n_max = 100000)

# First visualisation on fare price only

data1 <- subset(data0, select = c(key, fare_amount)) %>%
         filter(fare_amount > .5) %>%
         mutate(log_fare = log(fare_amount))

data_summary <- function(x) {
  m <- mean(x)
  ymin <- m - sd(x)
  ymax <- m + sd(x)
  return(c(y = m,ymin = ymin,ymax = ymax))
}

fare_histo_plot <- function(data) {
  g <- ggplot(data, aes(x = log_fare)) +
      geom_histogram(aes(y=..density..), colour = "black", fill = "aliceblue") +
      geom_density(alpha = .2, fill = "red") +
      ggtitle(label = "Taxi fare price histogramm and density estimation") +
      xlab("taxi fare price (in log($))")
  return(g)
}

g1 <- fare_histo_plot(data1)

# One can notice that the distribution looks like a Poisson (mean = variance)

data2 <- mutate(data1, week_day = wday(data1$key, label = TRUE)) %>%
             select(fare_amount, week_day) %>%
             mutate(log_fare = log(fare_amount))

g2 <- ggplot(data2, aes(x = week_day, y = log_fare)) +
          geom_violin(colour = "black", fill = "cadetblue1") +
          xlab("day of the week") + 
          ylab("taxi fare price (in log($))") +
          stat_summary(fun.data = data_summary, colour = "red")

g3 <- fare_histo_plot(data2) + facet_grid(. ~ week_day)

# Spatial Data

bounding_box <- c(-74.5, -72.8, 40.5, 41.8)

data3 <- data0 %>% 
         filter(pickup_longitude > bounding_box[1], pickup_longitude < bounding_box[2]) %>%
         filter(dropoff_longitude > bounding_box[1], dropoff_longitude < bounding_box[2]) %>%
         filter(pickup_latitude > bounding_box[3], pickup_latitude < bounding_box[4]) %>%
         filter(dropoff_latitude > bounding_box[3], dropoff_latitude < bounding_box[4]) %>%
         mutate(log_trip_distance = log(sqrt((pickup_longitude - dropoff_longitude)^2 + (pickup_latitude - dropoff_latitude)^2)), 
                trip_distance = sqrt((pickup_longitude - dropoff_longitude)^2 + (pickup_latitude - dropoff_latitude)^2))

g5 <- ggplot(data3, aes(x = trip_distance)) +
  geom_histogram(aes(y=..density..), colour = "black", fill = "aliceblue") +
  geom_density(alpha = .2, fill = "red") +
  ggtitle(label = "Density estimation for the trip distance") 

g6 <- ggplot(data3 %>% filter(trip_distance < .9), aes(x = trip_distance, y = fare_amount)) +
      geom_point(colour = "black") +
      geom_smooth()
      


  
