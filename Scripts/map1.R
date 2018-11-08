library(tidyverse)
library(readr)
library(magrittr)
library(ggmap)

#charger les données 
data0 <- read_csv(file = 'Data/train.csv', n_max = 1000)

s <- summary(data0$pickup_longitude)

#Enlève les valeurs fausses
data0 <- data0 %>% filter(pickup_longitude < s[5]) %>% filter(pickup_longitude > s[1])

qmplot(pickup_longitude, pickup_latitude, data = data0, zoom = 13, maptype = "terrain")



























































