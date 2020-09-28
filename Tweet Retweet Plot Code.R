####Set the working drive####
setwd("C:\\Users\\ANOYMISED")

####Check the working drive is correct####
getwd()

####Load the packages that you need####
library(readr)
library(jsonlite)
library(rtweet)
library(ggthemes)
library(ggplot2)
library(dplyr)
library(tidytext)
library(tidyr)

####Read in data####
df<-stream_in(file("C:\\...\\All Data.json"))

####Theme function####
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
### Create Plot
df%>%
  group_by(Game, is_retweet) %>%
  ts_plot("days", lwd = 1.0) +
  labs( x = "Time", 
        y = "Number of tweets",
        title = "Comparison of tweets/retweets",
        colour = "Game")+
  scale_color_manual("Game", values=c("MW"="green3", "OW"="orange"),labels=c("MW"="Modern Warfare", "OW"="Outer Worlds"))+
  labs(color="Game",linetype="Retweet")+
  facet_grid(Game~.)+
  our_theme()
