library(tidyverse)

by_pick <- read_rds("data/prod_by_draft_pick.RDS")

raw_draft <- read_csv("data/draft78.csv", col_names = T)

adv_stats_78_16 <- read_csv("data/adv_stats_78_16.csv", col_names = T)

adv_stats_78_16 = adv_stats_78_16 %>% 
  select(-.,
         -._1)

adv_stats_78_16 = adv_stats_78_16 %>% 
  set_names(~str_replace(., fixed("%"), "_perc")) %>% 
  set_names(~str_replace(., fixed("w/o"), "without")) %>% 
  set_names(~str_replace(., fixed("/"), "per")) %>% 
  set_names(~str_replace(., fixed("-"), "_")) %>% 
  set_names(~str_replace(., fixed("3"), "three_pt")) %>% 
  set_names(snakecase::to_snake_case) 



