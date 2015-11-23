require(tidyr)
require(dplyr)
require(ggplot2)

setwd("~/Desktop/DV_TProject1/01 Data")

file_path <- "data.reformatted.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)
summary(df)
head(df)
