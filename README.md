# draft

The goal of draft is to anaylze the relationship between draft pick and player performance.  

I have contract data as well so the idea is to measure player worth conditional on salary by draft pick. 

Question: Are players drafted in a certain range worth more to their team overall?   
  If so, how about after taking into account salaries?
  
##what data I have: 

1. **draft**     
⋅⋅1. file = data/draft78.csv  
⋅⋅2. what it has:  
⋅⋅⋅⋅⋅⋅⋅player name   
⋅⋅⋅⋅⋅⋅⋅years in league   
⋅⋅⋅⋅⋅⋅⋅draft year   
⋅⋅3.source:    
⋅⋅⋅⋅⋅*? not sure*  

1. **advanced stats from 1978-2016**  
⋅⋅1. file ="data/adv_stats_78_16.csv"  
⋅⋅2. what it has:   
⋅⋅⋅⋅⋅⋅player and team by year (78-16)  
⋅⋅⋅⋅⋅lots of advanced stats (>100 stats)  
⋅⋅⋅⋅⋅⋅⋅draft year   
⋅⋅3.source:    
⋅⋅⋅⋅bball_reference  

1. **bball_ref_player_list**    
⋅⋅1. file = "data/bball_ref_player_list.RDS"    
⋅⋅2. what it has:   
⋅⋅⋅⋅⋅list of players and first and last year in the league    
⋅⋅⋅⋅⋅pos   
⋅⋅⋅⋅⋅ht     
⋅⋅⋅⋅⋅birth_day     
⋅⋅⋅⋅⋅college    
⋅⋅⋅⋅⋅slug (player_id) **may be useful for matching**   
⋅⋅3.source:    
⋅⋅⋅⋅bball_reference

1. **bball_ref_season_summary**    
⋅⋅1. file = "../data/made_datasets/bball_ref/season_summary/"  
⋅⋅⋅⋅⋅ file names == "bball_ref_yyyy" where year is last year in season       
⋅⋅⋅⋅⋅*this is stored in a different file location currently*       
⋅⋅2. what it has:   
⋅⋅⋅⋅season stats for players by team     
⋅⋅3.source:     
⋅⋅⋅⋅bball_reference
