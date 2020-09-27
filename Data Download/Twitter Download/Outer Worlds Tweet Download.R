setwd("C:\\Users\\ANOYMISED")
getwd()

date<-Sys.Date()

####Functions and Libraries####
library(readr)
library(jsonlite)
library(rtweet)

create_token(
  app="ImpactLab_RStudio_Workshop",
  consumer_key="ANONYMISED",
  consumer_secret="ANONYMISED",
  access_token="ANONYMISED", 
  access_secret="ANONYMISED")

#### #Outer Worlds ####
df <- search_tweets(
  q = "#TheOuterWorlds", n = 18000, lang=c("en", "fr")
)

df %>% toJSON() %>% write_lines(paste0("#outerworlds tweets.json"))
test<-stream_in(file("#outerworlds tweets 2019-10-30.json"))

####outer+worlds####
df2 <- search_tweets(
  q = "\"outer worlds\"", n=18000, lang="en"
)

df2 %>% toJSON() %>% write_lines(paste0("Outer worlds tweets ", date, ".json"))

test<-stream_in(file("Outer Worlds tweets 2019-10-29.json"))

######################################################################
####Binding data sets####
##stream back in all data sets##
post_a<-stream_in(file("C:\\Users\\...\\Post-Release MW Data.json"))
post_b<-stream_in(file("C:\\Users\\...\\CoD_Post-Release Data.json"))

##bind##
post_release_data<-rbind(post_a, post_b)

##remove duplicates##
post_release_data<-unique.data.frame(post_release_data)

##remove any tweets created before the release date##
post_release_data<-post_release_data[(post_release_data$created_at>"2019-10-25 00:00:00"),]

##save as json file##
post_release_data %>% toJSON() %>% write_lines("C:\\Users\\...\\Modern Warfare Post-Release Data.json")

test<-stream_in(file("C:\\Users\\...\\Modern Warfare Post-Release Data.json"))

####Merge and new factors####
a<-stream_in(file("C:\\Users\\....\\Modern Warfare Pre-Release Data.json"))
a$Game<-"MW"

b<-stream_in(file("C:\\Users\\...\\Modern Warfare Post-Release Data.json"))
b$Game<-"MW"

c<-stream_in(file("C:\\Users\\...\\Outer Worlds Pre-Release Data.json"))
c$Game<-"OW"

d<-stream_in(file("C:\\Users\\...\\Outer Worlds Post-Release Data.json"))
d$Game<-"OW"

data_frame<-rbind(a,b,c,d)
data_frame$Game<-as.factor(data_frame$Game)

data_frame$Time<-ifelse(data_frame$created_at<"2019-10-25 00:00:00", "Pre", "Post" )
data_frame$Time<-as.factor(data_frame$Time)

data_frame %>% toJSON() %>% write_lines("C:\\Users\\...\\All Data.json")

test<-stream_in(file("C:\\Users\\...\\All Data.json"))