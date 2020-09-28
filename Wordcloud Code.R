setwd("C:\\Users\\ANONYMISED")
###Check the working drive###
getwd()

### Load the required packages ###
library(readr)
library(jsonlite)
library(rtweet)
library(ggplot2)
library(ggthemes)
library(dplyr)
library(readr)
library(tidytext)
library(tidyr)
library(lubridate)
library(wordcloud)
library(wordcloud2)


date<-Sys.Date()

### Load our function for plot themes ###
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

### Stream in Data Frame ###
data_frame_twitter<-stream_in(file("C:\\...\\All Data.json"))

#
######################################################################
####Read in the data (I have called the data frame mw_pre_df for modern warfare, pre-release data frame)####
mw_pre_df<-stream_in(file("Modern Warfare Pre-Release Data.json"))


#### Clean the data ####
## Remove any weblinks that are embedded in the tweets ##
mw_pre_df<-subset(data_frame_twitter, data_frame_twitter$Game=="MW" & Time=="Pre")

mw_pre_df$stripped_text <- gsub("http.*","",  mw_pre_df$text)
mw_pre_df$stripped_text <- gsub("https.*","", mw_pre_df$stripped_text)
mw_pre_df$stripped_text <- gsub("amp","", mw_pre_df$stripped_text)

#### Unest_tokens function is included in the tidytext package and cleans the data, changing any capitals to lowercase, removing emojis, removing punctuation etc. 
#### It will create a new data frame that is simply a list of all of the words contained in all of the tweets ####
mw_pre_df_clean<-mw_pre_df%>%
  select(stripped_text) %>% 
  mutate(tweetnumber=row_number()) %>% # create new variable denoting the tweet number
  unnest_tokens(word, stripped_text)

#### This will contain a lot of words that are not required but are frequently used (for example 'the' 'in' 'and' and so on). We need to remove these. 
#### There is a list of commonly used words called 'stop words' that we can use to remove these extra words.

## Load the stop words ##
data("stop_words")

## Remove the stop words ##
mw_pre_df_clean<-mw_pre_df_clean%>%
  anti_join(stop_words)

#### The tweets will also contain words that we know will be popular but are not really relevant for the word cloud, like the names of the games etc. 
#### We can remove these by setting our own stop-words ####

#### Set your own stop-words ####
my_stop_words<-data.frame(word = c("call", "duty", "modern", "warfare", "activision", "cod", "modernwarfare", "callofduty", "3", "2", "1", "10", "callofdutymodernwarfare"))

#### remove your stop-words from the data frame ####
mw_pre_df_clean<-mw_pre_df_clean%>%
  anti_join(my_stop_words)

#### Calculate the frequency of each word and sort by frequency (most common words first)
mw_pre_df_sorted<-mw_pre_df_clean %>%
  count(word, sort = TRUE) %>% 
  mutate(freq = n / sum(n))

#
#### Create the wordcloud (style 1) ####
mw_pre_wordcloud<-with(mw_pre_df_sorted, #include cleaned, sorted data frame
                       wordcloud(word, freq, 
                                 min.freq = 10, #minimum frequency (can be changed)
                                 max.words = 50, #maximum number of words in the cloud (can be changed)
                                 random.order = FALSE, 
                                 colors = brewer.pal(8, "RdYlGn"), #colours scheme (can be changed)
                                 scale = c(4.5, 0.1)))

#
#### Create the wordcloud (style 2) ####
mw_pre_df_2 <- mw_pre_df_sorted %>% select(word, freq)

# Produce wordcloud
mw_pre_wordcloud_2<-wordcloud2(mw_pre_df_2)

####Notes####
#If you find that there are useless words in the word cloud, you can change the contents of 'my_stop_words' and then run the code again.
#It doesn't matter if you choose Style 1 or Style 2, whichever you like the best!
#With style 1, if you want to change the colours, you can view the choices by running the following code:
display.brewer.all()
#you can then change 'dark2' to the name of whichever colour scheme you like the best.

#
### Repeat process for Post-Release Data
######################################################################
#### Read in the data (I have called the data frame mw_post_df for modern warfare, post-release data frame) ####
mw_post_df<-stream_in(file("Modern Warfare post-Release Data.json"))


mw_post_df<-subset(data_frame_twitter, data_frame_twitter$Game=="MW" & Time=="Post")

#### Clean the data ####
## Remove any weblinks that are embedded in the tweets ##
mw_post_df$stripped_text <- gsub("http.*","",  mw_post_df$text)
mw_post_df$stripped_text <- gsub("https.*","", mw_post_df$stripped_text)
mw_post_df$stripped_text <- gsub("amp","", mw_post_df$stripped_text)

####Unest_tokens function is included in the tidytext package and cleans the data, changing any capitals to lowercase, removing emojis, removing punctuation etc. 
#### It will create a new data frame that is simply a list of all of the words contained in all of the tweets ####
mw_post_df_clean<-mw_post_df%>%
  select(stripped_text) %>% 
  mutate(tweetnumber=row_number()) %>% # create new variable denoting the tweet number
  unnest_tokens(word, stripped_text)

## Load the stop words ##
data("stop_words")

## Remove the stop words ##
mw_post_df_clean<-mw_post_df_clean%>%
  anti_join(stop_words)

#### Set your own stop-words ####
my_stop_words<-data.frame(word = c("call", "duty", "modern", "warfare", "activision", "cod", "modernwarfare", "callofduty"))

#### Remove your stop-words from the data frame ####
mw_post_df_clean<-mw_post_df_clean%>%
  anti_join(my_stop_words)

#### Calculate the frequency of each word and sort by frequency (most common words first)
mw_post_df_sorted<-mw_post_df_clean %>%
  count(word, sort = TRUE) %>% 
  mutate(freq = n / sum(n))

#### Create the wordcloud (style 1) ####
mw_post_wordcloud<-with(mw_post_df_sorted, #include cleaned, sorted data frame
                        wordcloud(word, freq, 
                                  min.freq = 10, #minimum frequency (can be changed)
                                  max.words = 50, #maximum number of words in the cloud (can be changed)
                                  random.order = FALSE, 
                                  colors = brewer.pal(8, "Dark2"), #colours scheme (can be changed)
                                  scale = c(4.5, 0.1)))

####Create the wordcloud (style 2)####
mw_post_df_2 <- mw_post_df_sorted %>% select(word, freq)

# Produce wordcloud
mw_post_wordcloud_2<-wordcloud2(mw_post_df_2)

#
### Same Procedure for Outer Worlds Data
######################################################################
#### Read in the data (I have called the data frame ow_pre_df for outer worlds, pre-release data frame) ####
ow_pre_df<-stream_in(file("Outer Worlds Pre-Release Data.json"))

#### Clean the data ####
## Remove any weblinks that are embedded in the tweets ##
ow_pre_df$stripped_text <- gsub("http.*","",  ow_pre_df$text)
ow_pre_df$stripped_text <- gsub("https.*","", ow_pre_df$stripped_text)
ow_pre_df$stripped_text <- gsub("amp","", ow_pre_df$stripped_text)

####Unest_tokens function is included in the tidytext package and cleans the data, changing any capitals to lowercase, removing emojis, removing punctuation etc. 
####It will create a new data frame that is simply a list of all of the words contained in all of the tweets####
ow_pre_df_clean<-ow_pre_df%>%
  select(stripped_text) %>% 
  mutate(tweetnumber=row_number()) %>% # create new variable denoting the tweet number
  unnest_tokens(word, stripped_text)

## Load the stop words ##
data("stop_words")

## Remove the stop words ##
ow_pre_df_clean<-ow_pre_df_clean%>%
  anti_join(stop_words)

#### Set your own stop-words ####
my_stop_words<-data.frame(word = c("outer worlds" , "OW"))

#### Remove your stop-words from the data frame ####
ow_pre_df_clean<-ow_pre_df_clean%>%
  anti_join(my_stop_words)

#### Calculate the frequency of each word and sort by frequency (most common words first)
ow_pre_df_sorted<-ow_pre_df_clean %>%
  count(word, sort = TRUE) %>% 
  mutate(freq = n / sum(n))

#### Create the wordcloud (style 1) ####
ow_pre_wordcloud<-with(ow_pre_df_sorted, #include cleaned, sorted data frame
                       wordcloud(word, freq, 
                                 min.freq = 10, #minimum frequency (can be changed)
                                 max.words = 60, #maximum number of words in the cloud (can be changed)
                                 random.order = FALSE, 
                                 colors = brewer.pal(8, "Dark2"), #colours scheme (can be changed)
                                 scale = c(4.5, 0.1)))

#### Create the wordcloud (style 2) ####
ow_pre_df_2 <- ow_pre_df_sorted %>% select(word, freq)

# Produce wordcloud
ow_pre_wordcloud_2<-wordcloud2(ow_pre_df_2)


######################################################################
####Read in the data (I have called the data frame ow_post_df for outer world, post-release data frame)####
ow_post_df<-stream_in(file("Outer Worlds post-Release Data.json"))

#### Clean the data ####
## Remove any weblinks that are embedded in the tweets ##
ow_post_df$stripped_text <- gsub("http.*","",  ow_post_df$text)
ow_post_df$stripped_text <- gsub("https.*","", ow_post_df$stripped_text)
ow_post_df$stripped_text <- gsub("amp","", ow_post_df$stripped_text)

#### Unest_tokens function is included in the tidytext package and cleans the data, changing any capitals to lowercase, removing emojis, removing punctuation etc. 
#### It will create a new data frame that is simply a list of all of the words contained in all of the tweets ####
ow_post_df_clean<-ow_post_df%>%
  select(stripped_text) %>% 
  mutate(tweetnumber=row_number()) %>% # create new variable denoting the tweet number
  unnest_tokens(word, stripped_text)

## Load the stop words ##
data("stop_words")

## Remove the stop words ##
ow_post_df_clean<-ow_post_df_clean%>%
  anti_join(stop_words)

#### Set your own stop-words ####
my_stop_words<-data.frame(word = c("outer worlds" , "OW"))

#### Remove your stop-words from the data frame ####
ow_post_df_clean<-ow_post_df_clean%>%
  anti_join(my_stop_words)

#### Calculate the frequency of each word and sort by frequency (most common words first)
ow_post_df_sorted<-ow_post_df_clean %>%
  count(word, sort = TRUE) %>% 
  mutate(freq = n / sum(n))

#### Create the wordcloud (style 1) ####
ow_post_wordcloud<-with(ow_post_df_sorted, #include cleaned, sorted data frame
                        wordcloud(word, freq, 
                                  min.freq = 10, #minimum frequency (can be changed)
                                  max.words = 50, #maximum number of words in the cloud (can be changed)
                                  random.order = FALSE, 
                                  colors = brewer.pal(8, "Dark2"), #colours scheme (can be changed)
                                  scale = c(4.5, 0.1)))

#### Create the wordcloud (style 2) ####
ow_post_df_2 <- ow_post_df_sorted %>% select(word, freq)

# Produce wordcloud
ow_post_wordcloud_2<-wordcloud2(ow_post_df_2)
