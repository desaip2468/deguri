library(ggplot2)
library(plyr) # splat
library(purrr) # map

source("multiplot.R")

csv <- read.csv("output.csv")
headers <- c("M0001","M0002","M0003","M0004","M0005","M0006","M0007","M0008","M0009","M0010","M0011","M0012","M0013","M0014","M0015","M0016","M0017","M0018","M0019","M0020","M0021","M0022","M0023","M0024","M0025","M0026","M0027")
splat(multiplot)(map(headers, function(x){
  ggplot(csv, aes_string("group", x, fill="group")) +
    geom_bar(stat = "identity", position = "dodge") +
    geom_text(aes_string(label = x))
}), cols=6)
