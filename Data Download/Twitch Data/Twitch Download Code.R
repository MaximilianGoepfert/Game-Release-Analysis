install.packages("remotes")
remotes::install_github("Freguglia/rTwitchAPI")

library(remotes)
library(rTwitchAPI)
library(jsonlite)
library(tidyr)
library(readr)
library(dplyr)

#
##
## Reading the Client-ID from a file for the example, but you can assign directly
my_client_id <- "ANONYMISED"

#
##
## Setup authentication
twitch_auth(my_client_id)

#
##
## An example request to the streams endpoint
streams_live6 <- get_streams(first = 15, language = "en")
streams_live6$data


top_games6 <- get_top_games(first = 20)
top_games6$data

#
##
## Turn data frame into JSON file

streams_live$data %>% toJSON() %>% write_lines(paste0("twitch_streams 2019-10-25.json"))
test<-stream_in(file("twitch_streams 2019-10-25.json"))

top_games$data %>% toJSON() %>% write_lines(paste0("twitch_topgames 2019-10-25.json"))
test<-stream_in(file("twitch_topgames 2019-10-25.json"))

######################################################################
#
##
## Binding and mutating the full data sets

#
##
## Stream back in all data sets

setwd("C:\\Users\\ANONYMISED")

post_a<-stream_in(file("twitch_streams 2019-10-25.json"))
post_b<-stream_in(file("twitch_streams 2019-10-26.json"))
post_c<-stream_in(file("twitch_streams 2019-10-27.json"))
post_d<-stream_in(file("twitch_streams 2019-10-28.json"))
post_e<-stream_in(file("twitch_streams 2019-10-29.json"))
post_f<-stream_in(file("twitch_streams 2019-10-30.json"))

#
##
## Mutate data to add a date field to each of the files before binding together

post_25 <- mutate (post_a,date = "25-10-2019")
post_26 <- mutate (post_b,date = "26-10-2019")
post_27 <- mutate (post_c,date = "27-10-2019")
post_28 <- mutate (post_d,date = "28-10-2019")
post_29 <- mutate (post_e,date = "29-10-2019")
post_30 <- mutate (post_f,date = "30-10-2019")

#
##
## Bind

twitch_stream_data<-rbind(post_25, post_26, post_27, post_28, post_29, post_30)

#
##
## Update to include the game name fromt the game id

twitch_stream_data <- mutate (twitch_stream_data, name =
                                ifelse (game_id == "512710", "Call of Duty: Modern Warfare",
                                        ifelse (game_id == "510580", "The Outer Worlds", "Not Required")))

#
##
## Donvert data frame to JSON file

twitch_stream_data %>% toJSON() %>% write_lines(paste0("Twitch Stream Data.json"))

test<-stream_in(file("Twitch Stream Data.json"))


######################################################################
#
##
## Binding and mutating the full data sets

#
##
## Stream back in all data sets
post_a<-stream_in(file("twitch_topgames 2019-10-25.json"))
post_b<-stream_in(file("twitch_topgames 2019-10-26.json"))
post_c<-stream_in(file("twitch_topgames 2019-10-27.json"))
post_d<-stream_in(file("twitch_topgames 2019-10-28.json"))
post_e<-stream_in(file("twitch_topgames 2019-10-29.json"))
post_f<-stream_in(file("twitch_topgames 2019-10-30.json"))

#
##
## Mutate data to add a date field to each of the files before binding together

post_25 <- mutate (post_a,date = "25-10-2019")
post_26 <- mutate (post_b,date = "26-10-2019")
post_27 <- mutate (post_c,date = "27-10-2019")
post_28 <- mutate (post_d,date = "28-10-2019")
post_29 <- mutate (post_e,date = "29-10-2019")
post_30 <- mutate (post_f,date = "30-10-2019")

#
##
## Mutate to add the game position for each day

post_25a <- mutate (post_25,position = row_number())
post_26a <- mutate (post_26,position = row_number())
post_27a <- mutate (post_27,position = row_number())
post_28a <- mutate (post_28,position = row_number())
post_29a <- mutate (post_29,position = row_number())
post_30a <- mutate (post_30,position = row_number())

#
##
## Bind

twitch_topgames_data<-rbind(post_25a, post_26a, post_27a, post_28a, post_29a, post_30a)

twitch_topgames_data %>% toJSON() %>% write_lines(paste0("Twitch Top Games Data.json"))

test<-stream_in(file("Twitch Top Games Data.json"))
