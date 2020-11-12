library(tidyverse)
library(httr)
library(lubridate)

df <- read.csv("https://raw.githubusercontent.com/M3IT/COVID-19_Data/master/Data/COVID_AU_state_daily_change.csv", header=TRUE) %>% 
  mutate(date = ymd(date), 
         state_abbrev = as.character(state_abbrev))

df <- df %>% 
  filter(date>=mdy("April 8th, 2020")) %>% 
  filter(date<=mdy("November 3rd, 2020")) 
  
saveRDS(df, "data/refdata.RDS")
