setwd("C:\\Users\\...\\Social Media")
getwd()

date<-Sys.Date()

####Functions and Libraries####
library(readr)
library(jsonlite)
library(rtweet)


#### #ModernWarfare ####
mw <- search_tweets(
  q = "#modernwarfare", n = 18000, lang="en"
)

mw %>% toJSON() %>% write_lines(paste0("#modernwarfare tweets ", date, ".json"))
test<-stream_in(file("#modernwarfare tweets 2019-10-30.json"))

####Modern Warfare####

mw2 <- search_tweets(
  q = "\"modern warfare\"", n=18000, lang="en"
)

mw2 %>% toJSON() %>% write_lines(paste0("Modern Warfare tweets ", date, ".json"))
test <- stream_in(file("Modern Warfare Tweets 2019-10-30.json"))

### POST RELEASE DATE ###


######################################################################
####Binding data sets####
##stream back in all data sets##
post_a<-stream_in(file("#modernwarfare tweets 2019-10-25.json"))
post_b<-stream_in(file("#modernwarfare tweets 2019-10-26.json"))
post_c<-stream_in(file("#modernwarfare tweets 2019-10-27.json"))
post_d<-stream_in(file("#modernwarfare tweets 2019-10-28.json"))
post_e<-stream_in(file("#modernwarfare tweets 2019-10-30.json"))
post_f<-stream_in(file("Modern Warfare tweets 2019-10-25.json"))
post_g<-stream_in(file("Modern Warfare tweets 2019-10-26.json"))
post_h<-stream_in(file("Modern Warfare tweets 2019-10-27.json"))
post_i<-stream_in(file("Modern Warfare tweets 2019-10-28.json"))
post_j<-stream_in(file("Modern Warfare tweets 2019-10-30.json"))

##bind##
post_release_data<-rbind(post_a, post_b, post_c, post_d, post_e, post_f, post_g, post_h, post_i, post_j)

##remove duplicates##
post_release_data<-unique.data.frame(post_release_data)

##remove any tweets created after the release date##
post_release_data<-post_release_data[(post_release_data$created_at>"2019-10-25 00:00:00"),]

##save as json file##
post_release_data %>% toJSON() %>% write_lines(paste0("Post-Release MW Data.json"))

test<-stream_in(file("Post-Release MW Data.json"))

### PRE RELEASE ###

######################################################################
####Binding data sets####
##stream back in all data sets##
pre_a<-stream_in(file("#modernwarfare tweets 2019-10-24.json"))
pre_b<-stream_in(file("Modern Warfare tweets 2019-10-24.json"))

##bind##
pre_release_mwdata<-rbind(pre_a, pre_b)

##remove duplicates##
pre_release_mwdata<-unique.data.frame(pre_release_mwdata)

##save as json file##
pre_release_mwdata %>% toJSON() %>% write_lines(paste0("Pre-Release MW Data.json"))

test<-stream_in(file("Pre-Release MW Data.json"))

