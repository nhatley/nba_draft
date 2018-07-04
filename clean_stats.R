library(tidyverse)


#comes from AWS infra ~/shared/NBA/code/draft_value.R
#by_pick <- read_rds("data/prod_by_draft_pick.RDS")

###stats
adv_stats_78_16 <- read_csv("data/adv_stats_78_16.csv", col_names = T)

adv_stats_78_16 = adv_stats_78_16 %>% 
  select(-.,
         -._1)

adv_stats_78_16 = adv_stats_78_16 %>% 
  set_names(~str_replace(., fixed("%"), "_perc")) %>% 
  set_names(~str_replace(., fixed("w/o"), "without")) %>% 
  set_names(~str_replace(., fixed("/"), "per")) %>% 
  set_names(~str_replace(., fixed("-"), "_")) %>% 
  set_names(~str_replace(., "^3", "three_pt")) %>% 
  set_names(snakecase::to_snake_case) 

###draft
raw_draft <- read_csv("data/draft78.csv", col_names = T) 
  
draft = raw_draft %>%   
  set_names(snakecase::to_snake_case) %>% 
  mutate(player_lower = str_to_lower(player),
          player_snake = snakecase::to_snake_case(player_lower),
          player_title = str_to_title(player)
  )

##add  teams 
#set_names(~str_replace(.x, "^(WEIGHT)(.+)(_W\\d+)", "F_WEIGHT_\\3")) %>% 
player_team_list = read_rds("data/team_player_master_list.RDS") %>% 
  mutate(years = str_squish(str_extract(game_set, "^(.*?)(\\s)"))) %>% 
  separate(years, 
           c("year_season_start", "year_season_end"), 
           sep = "-", 
           remove = FALSE) %>% 
  mutate(year_season_start = as.integer(year_season_start),
         year_season_end = as.integer(year_season_end),
         player_lower = str_to_lower(player),
         player_snake = snakecase::to_snake_case(player_lower),
         player_title = str_to_title(player)
         )

draft_fuzzy_match = player_team_list %>% 
  fuzzyjoin::fuzzy_left_join(draft, 
                             by = c("player_snake", draft = "year_season_start"),
                             match_fun = stringdist::stringdist)







