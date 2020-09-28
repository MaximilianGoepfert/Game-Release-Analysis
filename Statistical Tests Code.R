# Set working directory
setwd("C:\\Users\\ANOYMISED")

# Load necessary packages
library(dplyr)
library(ggplot2)
library(ggthemes)
library(jsonlite)
library(lubridate)
library(nortest)
library(readr)
library(remotes)
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

##### New steps###############################################################

#### Subset data by game and pre/post release ####
mw_pre <- as.data.frame(filter(df_sentiment, Game == "MW", Time == "Pre"))
mw_post <- as.data.frame(filter(df_sentiment, Game == "MW", Time == "Post"))
ow_pre <- as.data.frame(filter(df_sentiment, Game == "OW", Time == "Pre"))
ow_post <- as.data.frame(filter(df_sentiment, Game == "OW", Time == "Post"))

#
#### Test for normality ####
### Using qq-plot
qqnorm(mw_pre$score)
qqline(mw_pre$score)
### Using Anderson-Darling Test
ad.test(mw_pre$score)
# p-value < 0.05 -> reject H0 -> data NOT normally distributed!

### Repeat for post-release data
qqnorm(mw_post$score)
qqline(mw_post$score)
ad.test(mw_post$score)
# p-value < 0.05 -> reject H0 -> data NOT normally distributed!

### ...and for the Outer Worlds
qqnorm(ow_pre$score)
qqline(ow_pre$score)
ad.test(ow_pre$score)
# p-value < 0.05 -> reject H0 -> data NOT normally distributed!

qqnorm(ow_post$score)
qqline(ow_post$score)
ad.test(ow_post$score)
# p-value < 0.05 -> reject H0 -> data NOT normally distributed!
# However, we should note that our extremely large sample size influences the reliability of the Anderson-Darling Test.

##################################################

# 1) Is there a significant difference between mw_scores pre and post release?
# Seeing that the data is not normally distributed we need to use a non-parametric test, the wilcoxon rank sum test (also: Mann-Whitney U-Test)
# Please note that, since this is a non-parametric test it is actually not comparing the means but the MEDIAN!
# H0: Sentiment Score of mw_pre = Sample Score of mw_post
wilcox.test(mw_pre$score, mw_post$score, paired = F)
# p-value < 0.05 -> nullhypothesis can be refused -> there are significant differences!

# 2) Is there a significant difference between ow_scores pre and post release?
wilcox.test(ow_pre$score, ow_post$score, paired = F)
# p-value < 0.05 -> H0 can be rejected -> there are significant differences

# 3) Are there significant differences between the games before release?
wilcox.test(mw_pre$score, ow_pre$score, paired = F)
# p-value < 0.05 -> H0 can be rejected -> there are significant differences

# 4) Are there significant differences between the games after release?
wilcox.test(mw_post$score, ow_post$score, paired = F)
# p-value < 0.05 -> H0 can be rejected -> there are significant differences
# Modern Warfare, sentiment decreases following release, Outer Worlds sentiment increases #