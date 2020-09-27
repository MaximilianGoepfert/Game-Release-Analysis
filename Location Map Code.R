setwd("C:\\...\\Location Maps")
getwd()

date<-Sys.Date()

#
####Functions and Libraries####
library(readr)
library(jsonlite)
library(rtweet)
library(ggthemes)
library(ggplot2)
library(dplyr)

#
##Create basemap##
world_basemap <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map()

#
#### Outer Worlds Pre-Release ####
## Read in Data ##
ow_pre_df<-stream_in(file("C:\\...\\Outer Worlds Pre-Release Data.json"))

## Identify latitude/longitud e##
ow_pre_df_loc <- lat_lng(ow_pre_df)

##Data frame of just date created, latitude and longitude
ow_pre_df_loc_stripped <- data.frame(date_time = ow_pre_df_loc$created_at,
                                     long = ow_pre_df_loc$lng,
                                     lat = ow_pre_df_loc$lat)
ow_pre_df_loc_stripped<-na.omit(ow_pre_df_loc_stripped)

## Round co-ords ##
ow_pre_df_loc_grouped<-ow_pre_df_loc_stripped %>%
  mutate(long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(long_round, lat_round) %>%
  summarise(total_count = n()) %>%
  ungroup() 

## Create plot ##
ow_pre_map<-world_basemap + 
  geom_point(data=ow_pre_df_loc_grouped,
             aes(long_round, lat_round, size=total_count),
             color="orange", alpha=0.5) + 
  coord_fixed() +
  labs(title="Locations of The Outer Worlds pre-release tweets",
       subtitle="Note that only English language Tweets have been included",
       size="Number of Tweets")+
  theme(legend.position="right")
ggsave(ow_pre_map, file="Outer Worlds Pre-Release Location Map.jpg")


#
#### Outer Worlds Post-Releas e####
## Read in Data ##
ow_post_df<-stream_in(file("C:\\...\\Outer Worlds Post-Release Data.json"))

## Identify latitude/longitude ##
ow_post_df_loc <- lat_lng(ow_post_df)

##Data frame of just date created, latitude and longitude
ow_post_df_loc_stripped <- data.frame(date_time = ow_post_df_loc$created_at,
                                      long = ow_post_df_loc$lng,
                                      lat = ow_post_df_loc$lat)
ow_post_df_loc_stripped<-na.omit(ow_post_df_loc_stripped)

## Round co-ords ##
ow_post_df_loc_grouped<-ow_post_df_loc_stripped %>%
  mutate(long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(long_round, lat_round) %>%
  summarise(total_count = n()) %>%
  ungroup() 

## Create plot ##
ow_post_map<-world_basemap + 
  geom_point(data=ow_post_df_loc_grouped,
             aes(long_round, lat_round, size=total_count),
             color="orange", alpha=0.5) + 
  coord_fixed() +
  labs(title="Locations of The Outer Worlds post-release tweets",
       subtitle="Note that only English language Tweets have been included",
       size="Number of Tweets")+
  theme(legend.position="right")
ggsave(ow_post_map, file="Outer Worlds Post-Release Location Map.jpg")

#
#### Modern Warfare Pre-Release ####
## Read in Data ##
mw_pre_df<-stream_in(file("C:\\...\\Modern Warfare Pre-Release Data.json"))

## Identify latitude/longitude ##
mw_pre_df_loc <- lat_lng(mw_pre_df)

## Data frame of just date created, latitude and longitude
mw_pre_df_loc_stripped <- data.frame(date_time = mw_pre_df_loc$created_at,
                                     long = mw_pre_df_loc$lng,
                                     lat = mw_pre_df_loc$lat)
mw_pre_df_loc_stripped<-na.omit(mw_pre_df_loc_stripped)

## Round co-ords ##
mw_pre_df_loc_grouped<-mw_pre_df_loc_stripped %>%
  mutate(long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(long_round, lat_round) %>%
  summarise(total_count = n()) %>%
  ungroup() 

## Create plot ##
mw_pre_map<-world_basemap + 
  geom_point(data=mw_pre_df_loc_grouped,
             aes(long_round, lat_round, size=total_count),
             color="green", alpha=0.5) + 
  coord_fixed() +
  labs(title="Locations of Call of Duty:Modern Warfare pre-release tweets",
       subtitle="Note that only English language Tweets have been included",
       size="Number of Tweets")+
  theme(legend.position="right")
ggsave(mw_pre_map, file="Modern Warfare Pre-Release Location Map.jpg")


#
#### Modern Warfare Post-Release ####
## Read in Data ##
mw_post_df<-stream_in(file("C:\\...\\Modern Warfare Post-Release Data.json"))

## Identify latitude/longitude ##
mw_post_df_loc <- lat_lng(mw_post_df)

## Data frame of just date created, latitude and longitude
mw_post_df_loc_stripped <- data.frame(date_time = mw_post_df_loc$created_at,
                                      long = mw_post_df_loc$lng,
                                      lat = mw_post_df_loc$lat)
mw_post_df_loc_stripped<-na.omit(mw_post_df_loc_stripped)

## Round co-ords ##
mw_post_df_loc_grouped<-mw_post_df_loc_stripped %>%
  mutate(long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(long_round, lat_round) %>%
  summarise(total_count = n()) %>%
  ungroup() 

## Create plot ##
mw_post_map<-world_basemap + 
  geom_point(data=mw_post_df_loc_grouped,
             aes(long_round, lat_round, size=total_count),
             color="green", alpha=0.5) + 
  coord_fixed() +
  labs(title="Locations of Call of Duty:Modern Warfare post-release tweets",
       subtitle="Note that only English language Tweets have been included",
       size="Number of Tweets")+
  theme(legend.position="right")
ggsave(mw_post_map, file="Modern Warfare Post-Release Location Map.jpg")


#
#### Combined ####
## Read in Data ##
df<-stream_in(file("C:\\...\\All Data.json"))

## Identify latitude/longitude ##
df_loc<-lat_lng(df)

## Data frame of date created, latitude and longitude, pre- or post-release and game
df_loc_stripped<-data.frame(date_time=df_loc$created_at,
                            long=df_loc$lng,
                            lat=df_loc$lat, 
                            time=df_loc$Time, 
                            game=df_loc$Game)

##Remove any tweets with missing values
df_loc_stripped<-na.omit(df_loc_stripped)

## Round co-ords ##
df_loc_grouped<-df_loc_stripped %>%
  mutate(long_round = round(long, 2),
         lat_round = round(lat, 2)) %>%
  group_by(long_round, lat_round) %>%
  summarise(total_count = n()) %>%
  ungroup() 

## Create plot ##
game_tweet_map<-world_basemap + 
  geom_point(data=df_loc_stripped,
             aes(long, lat, colour=game))      + 
  coord_fixed() +
  labs(title="Locations of tweets by game",
       subtitle="Note that only English language Tweets have been included")+
  theme(legend.position="right")+
  scale_colour_manual("game", values=c("MW"="green3", "OW"="orange"))
ggsave(game_tweet_map, file="Location map by game.jpg")


### Map by time ####
game_tweet_map<-world_basemap + 
  geom_point(data=df_loc_stripped,
             aes(long, lat, colour=time))      + 
  coord_fixed() +
  labs(title="Locations of tweets by time",
       subtitle="Note that only English language Tweets have been included",
       size="Number of Tweets")+
  theme(legend.position="right")+
  scale_colour_manual("game", values=c("Pre"="green1", "Post"="orange1"))
ggsave(game_tweet_map, file="Location map by time.jpg")



}

#
#### Map used in markdown
## Read in data
df<-stream_in(file("C:\\...\\All Data.json"))

## Create custom theme ##
our_theme<-function(x){
  theme(plot.title=element_text(size=18, color="black"),
        plot.caption=element_text(size=14, color="black"),
        axis.text.x=element_text(size=8, color="black"),
        axis.title.x=element_text(size=12, color="black"),
        axis.text.y=element_text(size=8, color="black"),
        axis.title.y=element_text(size=12, color="black"),
        strip.text.x=element_text(size=12, color="black"),
        strip.text.y=element_text(size=12, color="black"),
        legend.position="right")

## Identify latitude/longitude ##
df_loc<-lat_lng(df)

## Data frame of date created, latitude and longitude, pre- or post-release and game
df_loc_stripped<-data.frame(date_time=df_loc$created_at,
                            long=df_loc$lng,
                            lat=df_loc$lat, 
                            time=df_loc$Time, 
                            game=df_loc$Game)

##Remove any tweets with missing values
df_loc_stripped<-na.omit(df_loc_stripped)

## Create basemap ##
world_basemap <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map()

## Create plot ##
game_tweet_map<-world_basemap + 
  geom_point(data=df_loc_stripped,
             aes(long, lat, colour=game))+ 
  coord_fixed() +
  labs(title="Locations of tweets by game",
       subtitle="Note that only English language Tweets have been included")+
  scale_colour_manual("game", values=c("MW"="green3", "OW"="orange"))+
  our_theme()
print(game_tweet_map)
