# 2019 Australian Federal Election Campaign Tweets
This is an analysis of tweets by the Prime Minister of Australia, Scott Morrison MP, and the then-Leader of the Opposition, Bill Shorten MP, during the 2019 Australian Federal Election.

| **Scott Morrison MP**  | **Bill Shorten MP** |
| ------------- | ------------- |
| [\@ScottMorrisonMP](http://www.twitter.com/ScottMorrisonMP)| [\@billshortenmp](http://www.twitter.com/billshortenmp)|
| 394,821 followers | 345,761 followers |
| Liberal Party :large_blue_circle: | Labor Party :red_circle: |


#### Content
This analysis is a work in progress and currently includes the following:

***Data Visualisation***

- [X] **Types:** Ratio of the types of tweets.
- [X] **Dates:** Numbers of tweets per day during the campaign.
- [X] **Devices:** Proportion of tweets at each hour of the day by device used.
- [X] **Word Frequency:** Most used words and the frequency words in tweets.
- [ ] **Content:** Content included in tweets such as photos and URLs.
- [ ] **Engagement:** Number of 'likes' and 'retweets'.


***Data Analysis***

- [ ] **Sentiment:** Analysis of sentiment of tweets.
- [ ] **Performace:** Analysis of the types of tweets that performed the best against the metric of engagements (likes and retweets).



## Data Collection, Processing and Cleaning
#### Connecting to Twitter
The tweets and accompanying tweet data from the two timelines, was retrieved using the `rtweet` library. *Note, this using this library does not permit the downloading of geographic information.*

```
shorten <- get_timeline("@billshortenmp", n = 3200)
morrison <- get_timeline("@ScottMorrisonMP", n = 3200)
```


#### Cleaning the Data
The data were then cleaned and stored in three dataframes, `shorten_campaign`, `morrison_campaign` and `leaders_campaign` (a merged dataframe of the aforementioned dataframes), and for analysis. This initial process included:

1. Converting the `created_at` variable, which held the dates and times tweets were collected at, to Australian Eastern Standard Time; 

2. Filtering the 3,200 tweets for only tweets tweeted during the 2019 Australian Federal Election Campaign (between 11 April 2019 and 18 May 2019);

3. Filtering the 90 variables to only include those required for analysis; and

4. Creating new variables.


***Variables included:*** name of the leader (`MP`); the date and time tweeted (`created_at`); the text of the tweet (`text`); the device used to tweet (`source`); the character length of the tweet (`display_text_width`); the type of tweet - original, reply, quote, or retweet (`type`); number of likes (`favorite_count`); number of retweets (`retweet_count`); hashtags used (`hashtags`); the link used (`urls_expanded_url`); the photo used (`media_expanded_url` & `media_type`); mentions used (`mentions_screen_name`); information about quoted tweets and retweets (`qr_favorite_count`, `qr_retweet_count`, `qr_name` & `qr_followers_count`).



## Visualising the Data
#### Types
Throughout the entirety of the campaign, Shorten tweeted 163 times and Morrison tweeted 131 times. These tweets consisted of organic tweets (*Shorten = 148 (90.8%); Morrison = 93 (71.0%)*), replies to tweets (*Shorten = 12 (7.4%); Morrison = 25 (19.1%)*), quotes (*Shorten = 3 (1.8%); Morrison = 3 (2.3%)*), and retweets (*Shorten = 0 (0.0%); Morrison = 10 (7.6%)*).

The following plot shows the ratio of organic tweets, replies, quotes and retweets by each leader.

![TypesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/TypesPlot.png)

#### Dates
Both leaders tweeted on average 4 tweets per day (*Shorten = 4.405; Morrison = 4.226*). Morrison tweeted between 1 and 18 tweets in any given day with the maximum occuring on the 12th of May, 5 days before election day. Other notable peaks occured during the media blackout period on the 16th of May (*n = 9 tweets*), on the day that early voting commenced on the 29th of April (*n = 9 tweets*), and just before the close of the electoral rolls on the 16th of April (*n = 9 tweets*).


Shorten tweeted between 1 and 10 tweets in any given day with the maximum occurring on the 14th of May, 3 days before election day. Shorten tweeted betwee 1 and 10 tweets over the campaign period. Other notable peaks occured on the 22nd, 24th and 26th of April (*n = 9, 8 & 8 tweets respectively*), the week between Easter Sunday and Anzac Day (two days which campaigning was paused). During this week, Shorten campaigned in the ultra-marginal seats of Herbert (Townsville) and Leichhardt (Cairns). On the 22nd of April, both leaders also responded to the devastating Easter Sunday bombings in Sri Lanka, which killed more than 250 people, including two Australians.


The following plot shows the number of tweets per day by each leader over the course of the campaign. It also includes key campaign milestones and public holidays in which both leaders agreed to a campaign truce.

![DatesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DatesPlot.png)


#### Devices
The majority of the leaders' tweets came from TweetDeck (*Shorten = 70 (42.9%); Morrison = 30 (22.9%)*) and an iPhone (*Shorten = 49 (30.1%); Morrison = 91 (69.5%)*). The minority came from a Twitter Web Client (*Shorten = 1 (0.6%); Morrison = 10 (7.6%)*). Shorten was the only leader to utilise Periscope (*Shorten = 43 (26.4%)*) during the campaign which he utilised to live-stream his press conferences. 

Tweets from Shorten's iPhone was most likely to occur at 8am (*16.3% of tweets*) and 6pm (*12.3% of tweets*). Tweets from TweetDeck were most likely to occur at 7am (*18.6% of tweets*), between 4pm and 5pm (*14.3% of tweets & 12.9% of tweets, respectively*), and at 7pm (*11.4% of tweets*) after the nightly news. Shorten streamed his morning press conferences via Periscope between 10am and 12pm (*10am = 16.3%; 11am = 32.6%; 12pm = 25.6%*).

Tweets from Morrison's iPhone was most likely to occur at 9am (*11% of tweets*) and 2pm (*13.2% of tweets*). Tweets from TweetDeck were most likely to occur at between 11am and 12pm (*23.3% of tweets & 20% of tweets, respectively*), at 4pm (*10% of tweets*), and between 6pm and 7pm (*10% of tweets & 13.3% of tweets, respectively*). Tweets from a Twitter Web Client generally occured between 10am and 12pm (*10am = 30%; 11am = 10%; 12pm = 40%*).

The following plot shows the proportion of tweets at each hour of the day by device by each leader. 

![DevicesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DevicesPlot.png)

#### Word Frequency
In order to analyse the word frequency of each leader, the data was cleaned and stored in two dataframes, `shorten_words` and `morrison words`. This process included: 

1. Removing all stop words, links, and punctuation; 

2. Filtering out 'retweets'; and

3. Lengthening the data into a new variable, `word`, containing each individual word from tweets.


Shorten tweeted a total of 1599 words and on average repeated words twice (*mean = 2.3*) during the campaign. The top ten words account for 17% of total words usage. These words were constistent with the Labor Party's negative messaging, including the *"liberal's cruel cuts to penalty rates, public hospitals, schools, childcare, universities, pensions, the ABC"* and that the liberals were only for the *"top end of town"*. It was also consistent with the Labor Party's positive messaging, including *"a fair go for australia"* and *"labor's fair go action plan"*.

***Shorten's top ten tweet words:***

| **Word**  | **Frequency** |
| ------------- | ------------- |
| labor | 48 |
| live | 43 |
| vote | 30 |
| cuts | 25 |
| labors | 22 |
| liberals | 22 |
| town | 22 |
| fair | 19 |
| change | 18 |
| plan | 18 |


Morrison tweeted a total of 1973 and on average repeated words twice (*mean = 1.9*) during the campaign. The top ten words account for 11% of total words usage. These words were constistent with the Liberal Party's positive messaging of *"building our economy, securing your future"*, *"delivering our plan"*, and *"keeping our economy strong, keeping Australians safe, and keping Australians together"*.

***Morrison's top ten tweet words:***

| **Word**  | **Frequency** |
| ------------- | ------------- |
| australians | 38 |
| economy | 31 |
| #buildingoureconomy | 23 |
| australia | 23 |
| plan | 23 |
| future | 16 |
| support | 16 |
| secure | 14 |
| business | 13 |
| country | 13 |



The following plot shows the difference in words tweeted by each leader and their frequency.

![WordcloudPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/WordcloudPlot.png)

#### Content

*NB. This is yet to be completed*



#### Engagement

*NB. This is yet to be completed*



## Analysing the Data
#### Sentiment Analysis

*NB. This is yet to be completed*



#### Performance

*NB. This is yet to be completed*


## Credits
Includes code inspired and adapted from the following sources:

- [David Robinson's Text Analysis of Trump's tweets](http://varianceexplained.org/r/trump-tweets/)

- [Drew Conway's Comparative Cloud](https://sites.google.com/site/miningtwitter/questions/talking-about/wordclouds/modified-cloud)