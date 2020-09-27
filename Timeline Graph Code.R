#
##
#### Set the working directory ####

setwd("C:\\ANONYMISED")

#
##
## Load the packages ####

library(rtweet)
library(ggplot2)
library(dplyr)
library(ggthemes)
library(readr)
library(jsonlite)
library(tidytext)
library(tidyr)
library(lubridate)

#### Theme function  ####
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
}

#
##
#### Read in the JSON files as data frames ####

twitchstream <- stream_in(file("C:\\...\\Twitch Stream Data.json"))
twitchgames <- stream_in(file("C:\\...\\Twitch Top Games Data.json"))
twitter_data <- stream_in(file("C:\\...\\All Data.json"))

#
##
#### Plots of tweets by volume across times ####

twitter_data %>%
  group_by(Game, Time) %>%
  ts_plot ('hours', lwd = 1, trim = 1) +
  labs (x = "Time (in hours)", y = "No. of Tweets", title = "Tweet Volume by Games", 
        subtitle = "Games released at midnight on 25th October 2019", colour = "Game") +
  scale_color_manual("Game", values = c("MW"="green3", "OW" = "Orange"), labels = c("MW" = "Call of Duty: Modern Warfare", "OW" = "The Outer Worlds", "Post" = "Post-Release", "Pre" = "Pre-Release"))  +
  facet_grid(Game~.) +
  our_theme()

#
##
#### Mutate to change the date string to date format ####

twitchgames_1 <- mutate (twitchgames,date = ymd(date))

#
##
#### Plot the position of games over time fitering out all other games ####

twitchgames_1 %>% 
  select (name, position, date) %>%
  filter (name %in% c("Call of Duty: Modern Warfare", "The Outer Worlds"))%>%
  ggplot(aes (x = date, y = position, col = name)) +
  labs (x = "Date", y = "Twitch Position", colour = "Game",
        title = "Games' Twitch Stream Position", subtitle = "Stream position by volume of daily views") +
  geom_line(size = 1, linetype = 1) +
  scale_y_reverse(breaks= seq(1,20, by = 1)) +
  scale_x_date(date_breaks = "1 day") +
  scale_color_manual(values = c("green3", "orange")) +
  our_theme()

#
##
#### Mutate to change the date string to date format ####

twitchstream_1 <- mutate (twitchstream,date = ymd(date))

#
##
#### Plot the number of stream views over time fitering out all other games ####

twitchstream_1 %>%
  select (name, viewer_count, date) %>%
  filter (name %in% c("Call of Duty: Modern Warfare", "The Outer Worlds"))%>%
  ggplot(aes (x = date, y = viewer_count, fill = name)) +
  labs (x = "Date", y = "Viewer Count", fill = "Game",
        title = "Games' Twitch Viewer Count", subtitle = "Stream views on Twitch at time of data extraction") +
  geom_bar(position = "dodge", stat = "identity") +
  scale_x_date(date_breaks = "1 day") +
  scale_fill_manual(values = c("green3", "orange")) +
  our_theme()
