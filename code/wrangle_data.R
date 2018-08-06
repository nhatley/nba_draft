library(tidyverse)

##see read me for existing data

#goal is end dataset with production by player + team wth columns for draft_pick and year
##note: ^ this is a bit tricky because of player names and matching on that
##want to use bball ref slug or some sort of player id if possible

##have this data
  #draft
  #adv_stats_78_16
  #bball_ref_player_list
  #bball_ref_season_summary

#function for names that just makes standardized columns e.g. snake case 

add_standardized_names = function(df, player_name) {
  #df = dataframe input
  #player_name = variable name for player's name
  
  player_name = rlang::sym(player_name)
  
  out <- df %>% 
    mutate(player_lower = str_to_lower(!!player_name),
                player_snake = snakecase::to_snake_case(player_lower),
                player_title = str_to_title(!!player_name)
  )
return(out)
}

###draft
raw_draft <- read_csv("data/draft78.csv", col_names = T) 

draft = raw_draft %>%   
  set_names(snakecase::to_snake_case) %>% 
  add_standardized_names(df = ., player_name = "player") %>% 
  rename(years_in_league = yrs,
         draft_year = draft)

###stats
adv_stats_78_16_rd <- read_csv("data/adv_stats_78_16.csv", col_names = T)

adv_stats_78_16 = adv_stats_78_16_rd %>% 
  select(-.,
         -._1) %>% 
  set_names(~str_replace(., fixed("%"), "_perc")) %>% 
  set_names(~str_replace(., fixed("w/o"), "without")) %>% 
  set_names(~str_replace(., fixed("/"), "per")) %>% 
  set_names(~str_replace(., fixed("-"), "_")) %>% 
  set_names(~str_replace(., "^3", "three_pt")) %>% 
  set_names(snakecase::to_snake_case) %>% 
  add_standardized_names(., "player")

bball_ref_player_list = read_rds("data/bball_ref_player_list.RDS") %>% 
  add_standardized_names(., "player")

##now want a function that reads in season summary and saves it out in current proj files
read_and_save_season_player_list = function(year, #year = 1978
                                            root) {#root = ".."
  
  
  direct_path = "data/made_datasets/bball_ref/season_summary"
  df_name = paste0("bball_ref_", year, ".RDS")
  
  path = file.path(root, direct_path, df_name)
  
  df = read_rds(path)
  
  ##don't need stat variables since those are in adv_stats_78_16
  
  out = df %>% 
    mutate(year = year) %>% 
    mutate(player = str_remove(player, "(\\*$)")) %>% 
    select(year, 
           player,
           pos,
           age,
           team = tm,
           games_started = gs,
           start_year,
           end_year
      ) %>% 
    add_standardized_names(., player_name = "player")
  
  save_path = file.path("data/bball_ref_season", df_name)
  
  saveRDS(out, save_path)
  
} 

years = 1978:2017

#this reads files and saves them in new location
walk(years, function(x) read_and_save_season_player_list(year = x, root = ".."))

read_and_bind_season_player_list = function(year, #year = 1978
                                            root) {#root = "data/bball_ref_season"
  
  df_name = paste0("bball_ref_", year, ".RDS")
  read_path = file.path(root, df_name)
  
  out = read_rds(read_path)
return(out)
} 

bball_ref_season_78_16 = map_df(years, function(x)
                              read_and_bind_season_player_list(
                                year = x, 
                                root = "data/bball_ref_season")) 

saveRDS(bball_ref_season_78_16, "data/bball_ref_season_78_16.RDS")


##now starts the merging of the various data sources


master_season_list = bball_ref_season_78_16  %>% 
  left_join(bball_ref_player_list %>% 
              mutate(flag_player_list = 1) %>% 
              #from here want to try player names
              select(player, 
                     slug, 
                     flag_player_list)
                     )
  
#this leaeves with us with: 
sum(is.na(master_season_list$slug))
#NA's

master_season_draft = master_season_list %>% 
  left_join(draft %>% 
              select(pick,
                     years_in_league,
                     draft_year,
                     player_snake) %>% 
              mutate(draft_flag = 1) 
            )

#this leaves us with:
sum(is.na(master_season_draft$draft_flag))
#NA's
master_season_draft_nas = master_season_draft %>% 
  filter(is.na(draft_flag))
#what years do nas come from?
hist(master_season_draft_nas$year)

total = nrow(master_season_draft_nas)  
na_years = master_season_draft_nas %>% 
  group_by(year) %>% 
  summarise(n = n(),
            prop = n/total)

theme_set(theme_bw())
qplot(na_years$year, na_years$prop) 

##it occurs to me that different years have different number of picks
draft_picks = draft %>% 
  group_by(draft_year) %>% 
  summarise(picks_made = max(pick))

qplot(draft_picks$draft_year, draft_picks$picks_made) 

#started the 59 pick model in 1989

master_season_draft_89_17 = master_season_list %>% 
  filter(year >= 1989) %>% 
  left_join(draft %>% 
              #filter(draft_year >= 1989) %>% 
              select(pick,
                     years_in_league,
                     draft_year,
                     player_snake) %>% 
              mutate(draft_flag = 1) 
  ) %>% 
  #have some duplicates
  distinct(year, player, team, .keep_all = TRUE)

##this limits NA's to 
sum(is.na(master_season_draft_89_17$draft_flag))

total = nrow(master_season_draft_89_17)  
na_years = master_season_draft_89_17 %>% 
  filter(is.na(draft_flag)) %>% 
  group_by(year) %>% 
  summarise(n = n(),
            prop = n/total)
qplot(na_years$year, na_years$prop)

na_players = master_season_draft_89_17 %>% 
  filter(is.na(draft_flag)) %>% 
  distinct(player)



# draft_fuzzy_match = player_team_list %>% 
#   fuzzyjoin::fuzzy_left_join(draft, 
#                              by = c("player_snake", draft = "year_season_start"),
#                              match_fun = stringdist::stringdist)






