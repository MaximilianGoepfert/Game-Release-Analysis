# Game Release Analysis: Project Overview
- Analysed the launch of video game titles 'Call of Duty: Modern Warfare' and 'The Outer Worlds' through Social Media analysis.
- Downloaded over 420'000 tweets as well as data from streaming platform Twitch, both collected during October 2019.
- Analysed the content, location, and timeline of downloaded tweets, also making use of statistical analysis.
- Compared the games' popularities on Twitch.

## Code and Resources Used
__R Version__: 3.6.2 \
__Packages__: tidyr, tidytext, dplyr, ggplot2, ggthemes, rtweet, jsonlite, readr, rTwitchAPI, remotes, nortest, lubridate, wordcloud, knitr \
__Twitch API__: https://github.com/Freguglia/rTwitchAPI \
__Twitter API__: https://developer.twitter.com/en/docs/twitter-api 

## Data Download
Twitter:
- Downloaded tweets that featured the keywords "TheOuterWorlds", "modernwarfare", or "CallofDuty" as a hashtag and/or contained in its text.
- For each keyword a maximum of 18'000 tweets per day were downloaded (where possible) for the period of 23 October to 30 October.
- The resulting data was saved in a json file; since this project can be classified as a 'Big Data' project, the resulting file cannot be provided here (due to GitHub's data size restrictions).

Twitch:
- Downloaded data from streaming platform twitch, focusing both on the total number of streams regarding both games and on their relative position within the twenty most streamed games.
- The resulting data was likewise saved in a json file and has been made available in the 'data' folder.

## Analysis
Performed in-depth graphical analysis of the collected data. A few of the plots can be found below.
![alt text](https://github.com/MaximilianGoepfert/Game-Release-Analysis/blob/master/StreamPosition.png "Twitch Most Streamed Games Position")
![alt text](https://github.com/MaximilianGoepfert/Game-Release-Analysis/blob/master/Outer_Worlds_Pre-Release_Location_Map.png "Location Map")
![alt text](https://github.com/MaximilianGoepfert/Game-Release-Analysis/blob/master/Tweet_timeline.png "Tweet Timeline")
<br>
Also performed statistical analysis on the tweets' sentiment scores, using the Wilcoxon Rank Sum test (also: Mann-Whitney U-Test):
- Checked for differences in the sentiment scores of each game pre- and post release
- Checked for differences in the sentiment scores of the games before release
- Checked for differences in the sentiment scores of the games after release

## Conclusions
- Twitter Presence:
  + Modern Warfare: Large twitter presence at point of release
  + Outer Worlds: Gradual build up of twitter presence throughout pre-release schedule
- Twitter Content:
  + Modern Warfare: Majority of tweets were retweets, relating to a ‘giveaway’ competition
  + Outer Worlds: Majority of tweets were unique suggesting a greater engagement with the pre-release programme
- Sentiment
  + Significant differences between the sentiment of tweets pre- and post-release
  + Modern Warfare: Sentiment reduced following release
  + Outer Worlds: Sentiment increased following release
- Sales Figures
  + Modern Warfare: Highest sales following release as expected from a well-known franchise.
  + Outer Worlds: Second highest sales in October - surprising for a game without an existing fanbase - suggesting a successful marketing strategy.


Work in progress...
