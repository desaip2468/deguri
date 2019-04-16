library(ggplot2)
library(plyr) # splat
library(purrr) # map
library(scales)

source("multiplot.R")

headers <- c("J0079", "J0080", "J0081")
colClasses <- c(map(headers, function(x){ "numeric" }), "numeric")
csv <- read.csv("output.csv", colClasses = colClasses)

splat(multiplot)(
  map(
    headers,
    function(x){
      ggplot(csv, aes_string("group", x, fill = "group")) +
        geom_bar(stat = "identity", position = "dodge") +
        geom_label(aes_string(label = x, fill = 1), colour = "white", fontface = "bold") +
        geom_label(aes_string(label = paste("percent(", x, "/ total)")), colour = "white", vjust = 1.5)
        # geom_label(aes(label = paste("from group ", group)), colour = "white", vjust = 2.5)
    }
  ),
  cols = 2
)
