library(tidyverse)
library(lubridate)
library(magrittr)

data0 <- read_csv("../Data/train.csv", n_max = 1000)

# First visualisation on fare price only

data1 <- subset(data0, select = c(key, fare_amount))

data_summary <- function(x) {
  m <- mean(x)
  ymin <- m - sd(x)
  ymax <- m + sd(x)
  return(c(y = m,ymin = ymin,ymax = ymax))
}

fare_histo_plot <- function(data) {
  g <- ggplot(data, aes(x = fare_amount)) +
      geom_histogram(aes(y=..density..), colour = "black", fill = "aliceblue") +
      geom_density(alpha = .2, fill = "red") +
      ggtitle(label = "Taxi fare price histogramm and density estimation") +
      xlab("taxi fare price (in $)")
  return(g)
}

g1 <- fare_histo_plot(data1)

# One can notice that the distribution looks like a Poisson (mean = variance)

data2 <- mutate(data1, week_day = wday(data1$key, label = TRUE)) %>%
           select(fare_amount, week_day) %>%
           group_by(week_day) %>%
           summarize(fare_amount_mean = mean(fare_amount), fare_amount_sd = sd(fare_amount))

data2_bis <- mutate(data1, week_day = wday(data1$key, label = TRUE)) %>%
             select(fare_amount, week_day)

g2 <- ggplot(data2, aes(x = week_day, y = fare_amount_mean)) +
      geom_violin(colour = "black", fill = "antiquewhite") +
      xlab("day of the week") + 
      ylab("mean taxi fare price (in $)") +
      ggtitle("Average taxi fare price per day") 

g2_bis <- ggplot(data2_bis, aes(x = week_day, y = fare_amount)) +
          geom_violin(colour = "black", fill = "cadetblue1") +
          xlab("day of the week") + 
          ylab("taxi fare price (in $)") +
          stat_summary(fun.data=data_summary)

g3 <- fare_histo_plot(data2_bis) + facet_grid(. ~ week_day)



