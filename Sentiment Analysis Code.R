# Set working directory
setwd("C:\\Users\\ANOYMISED")

# Load necessary packages
library(readr)
library(jsonlite)
library(rtweet)
library(ggthemes)
library(ggplot2)
library(dplyr)
library(tidytext)
library(tidyr)

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

### Stream in dataset
df <- stream_in(file("C:\\...\\All Data.json"))


### Cleaning the data - removing the weblinks
df$stripped_text <- gsub("http.*","",  df$text)
df$stripped_text <- gsub("https.*","", df$stripped_text)
df$stripped_text <- gsub("amp","", df$stripped_text)


### Cleaning the data - creating a list of all words (removes punctuation, emojis, etc.)
df_clean<-df %>% group_by(Game, Time) %>%
  select(stripped_text) %>% 
  mutate(tweetnumber=row_number()) %>%
  unnest_tokens(word, stripped_text)


### Cleaning the data - setting stop words
my_stopwords <- data.frame(word = c("modern", "warfare", "fallout", "halcyon"))
df_clean2 <- df_clean %>% anti_join(my_stopwords)


### Calculate sentiment score (all words)
### Associate scores to each tweet
df_sentiment <- df_clean2 %>% 
  inner_join(get_sentiments("bing")) %>%
  count(tweetnumber, sentiment) %>%
  spread(sentiment, n, fill = 0) %>% 
  mutate(score = positive - negative)


### Mean score
mean_score <- df_sentiment %>% 
  summarise(mean_score = mean(score))

#### Barplot
ggplot(df_sentiment, aes(x = score,fill=factor(Game))) +
  geom_bar() +
  geom_vline(aes(xintercept = mean_score), data = mean_score) +
  geom_text(aes(x = mean_score, 
                y = Inf,
                label = signif(mean_score, 3)),
            vjust = 2,
            data = mean_score) +
  labs(x = "Sentiment Score",
       y = "Number of tweets",
       fill="Game") +
  scale_x_continuous(breaks = c(-9, -6, -3, 0, 3, 6, 9),
                     minor_breaks = NULL) +
  facet_grid( Game ~ Time) +
  scale_fill_manual(name="Game", values=c("OW"="orange","MW"="green3"),labels=c("MW"="Modern Warfare", "OW"="The Outer Worlds"))+
  our_theme()
