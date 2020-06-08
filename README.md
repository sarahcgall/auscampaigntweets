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
- [X] **Engagement:** Number of 'likes' and 'retweets'.


***Data Analysis***

- [ ] **Sentiment:** Analysis of sentiment of tweets.
- [ ] **Performance:** Analysis of the types of tweets that performed the best against the metric of engagements (likes and retweets).



## Data Collection, Processing and Cleaning
#### Connecting to Twitter
The tweets and accompanying tweet data from the two timelines, was retrieved using the `rtweet` library. *Note, the `rtweet` library does not permit the downloading of geographic or user information without a Twitter API and therefore these data have not been included in the analysis.*

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


***Variables included:*** name of the leader (`MP`); the date and time tweeted (`created_at`); the text of the tweet (`text`); the device used to tweet (`source`); the character length of the tweet (`display_text_width`); the type of tweet - original, reply, quote, or retweet (`type`); number of likes (`favorite_count`); number of retweets (`retweet_count`); total number of likes and retweets (`total_count`); hashtags used (`hashtags`); the link used (`urls_expanded_url`); the photo used (`media_expanded_url` & `media_type`); mentions used (`mentions_screen_name`); information about quoted tweets and retweets (`qr_favorite_count`, `qr_retweet_count`, `qr_name` & `qr_followers_count`).



## Visualising the Data
#### Types
Throughout the entirety of the campaign, Shorten tweeted 163 times and Morrison tweeted 131 times. These tweets consisted of organic tweets (*Shorten = 148 (90.8%); Morrison = 93 (71.0%)*), replies to tweets (*Shorten = 12 (7.4%); Morrison = 25 (19.1%)*), quotes (*Shorten = 3 (1.8%); Morrison = 3 (2.3%)*), and retweets (*Shorten = 0 (0.0%); Morrison = 10 (7.6%)*).

The following plot shows the ratio of organic tweets, replies, quotes and retweets by each leader.

![TypesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/TypesPlot.png)

#### Dates
Both leaders tweeted on average 4 tweets per day (*Shorten = 4.405; Morrison = 4.226*). Morrison tweeted between 1 and 18 tweets in any given day with the maximum occurring on the 12th of May, 5 days before election day. Other notable peaks occurred during the media blackout period on the 16th of May (*n = 9 tweets*), on the day that early voting commenced on the 29th of April (*n = 9 tweets*), and just before the close of the electoral rolls on the 16th of April (*n = 9 tweets*).


Shorten tweeted between 1 and 10 tweets in any given day with the maximum occurring on the 14th of May, 3 days before election day. Shorten tweeted between 1 and 10 tweets over the campaign period. Other notable peaks occurred on the 22nd, 24th and 26th of April (*n = 9, 8 & 8 tweets, respectively*), the week between Easter Sunday and Anzac Day (two days which campaigning was paused). During this week, Shorten campaigned in the ultra-marginal seats of Herbert (Townsville) and Leichhardt (Cairns). On the 22nd of April, both leaders also responded to the devastating Easter Sunday bombings in Sri Lanka, which killed more than 250 people, including two Australians.


The following plot shows the number of tweets per day by each leader over the course of the campaign. It also includes key campaign milestones and public holidays in which both leaders agreed to a campaign truce.

![DatesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DatesPlot.png)


#### Devices
The majority of the leaders' tweets came from TweetDeck (*Shorten = 70 (42.9%); Morrison = 30 (22.9%)*) and an iPhone (*Shorten = 49 (30.1%); Morrison = 91 (69.5%)*). The minority came from a Twitter Web Client (*Shorten = 1 (0.6%); Morrison = 10 (7.6%)*). Shorten was the only leader to utilise Periscope (*Shorten = 43 (26.4%)*) during the campaign which he utilised to live-stream his press conferences. 

Tweets from Shorten's iPhone was most likely to occur at 8am (*16.3% of tweets*) and 6pm (*12.3% of tweets*). Tweets from TweetDeck were most likely to occur at 7am (*18.6% of tweets*), between 4pm and 5pm (*14.3% of tweets & 12.9% of tweets, respectively*), and at 7pm (*11.4% of tweets*) after the nightly news. Shorten streamed his morning press conferences via Periscope between 10am and 12pm (*10am = 16.3%; 11am = 32.6%; 12pm = 25.6%*).

Tweets from Morrison's iPhone was most likely to occur at 9am (*11% of tweets*) and 2pm (*13.2% of tweets*). Tweets from TweetDeck were most likely to occur at between 11am and 12pm (*23.3% of tweets & 20% of tweets, respectively*), at 4pm (*10% of tweets*), and between 6pm and 7pm (*10% of tweets & 13.3% of tweets, respectively*). Tweets from a Twitter Web Client generally occurred between 10am and 12pm (*10am = 30%; 11am = 10%; 12pm = 40%*).

The following plot shows the proportion of tweets at each hour of the day by device by each leader. 

![DevicesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DevicesPlot.png)

#### Word Frequency
In order to analyse the word frequency of each leader, the data was cleaned and stored in two dataframes, `shorten_words` and `morrison words`. This process included: 

1. Removing all stop words, links, capitalisation and punctuation; 

2. Filtering out 'retweets'; and

3. Lengthening the data into a new variable, `word`, containing each individual word from tweets.


Shorten tweeted a total of 1599 words and on average repeated words twice (*mean = 2.3*) during the campaign. The top ten words account for 17% of total words usage. These words were consistent with the Labor Party's negative messaging, including the *"liberal's cruel cuts to penalty rates, public hospitals, schools, childcare, universities, pensions, the ABC"* and that the liberals were only for the *"top end of town"*. It was also consistent with the Labor Party's positive messaging, including *"a fair go for australia"* and *"labor's fair go action plan"*.

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


Morrison tweeted a total of 1827 and on average repeated words twice (*mean = 1.9*) during the campaign. The top ten words account for 10% of total words usage. These words were consistent with the Liberal Party's positive messaging of *"building our economy, securing your future"*, *"delivering our plan"*, and *"keeping our economy strong, keeping Australians safe, and keeping Australians together"*.

***Morrison's top ten tweet words:***

| **Word**  | **Frequency** |
| ------------- | ------------- |
| australians | 38 |
| economy | 25 |
| #buildingoureconomy | 21 |
| australia | 20 |
| plan | 19 |
| future | 14 |
| support | 14 |
| home | 13 |
| australian | 12 |
| country | 12 |



The following plot shows the difference in words tweeted by each leader and their frequency.

![WordcloudPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/WordcloudPlot.png)

#### Content

*NB. This is yet to be completed*



#### Engagement
In order to analyse engagement of each leaders' tweets, the data was filtered to remove all retweets and therefore only included, organic tweets, quotes and replies.

Overall, Shorten's tweets received a total of 231,295 likes and retweets (*likes = 178,774, retweets = 52,521*) compared to Morrison's tweets which received a total of 71,912 likes and retweets (*likes = 60,855; retweets = 11,057*). This overall engagement demonstrates Shorten's dominance over Morrison. 

The following plot shows the frequency of each leaders' total engagement (likes & tweets) per tweet per day.

![TotalPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/TotalPlot.png)


Morrison had an average of 503 likes and 91 retweets per tweet. Likes and retweets per tweet ranged from a minimum 97 likes and 9 retweets to 4,155 likes and 593 retweets. Shorten had an average of 1097 likes and 322 retweets per tweet. Likes and retweets per tweet ranged from a minimum of 85 likes and 34 retweets to 13,629 likes and 2,986 retweets. A number of outliers related to key events during the campaign, most notedbly the death of former Labor Prime Minister, Bob Hawke. The top 10 tweets during the campaign highlight these key events.

***Top 10 tweets during the campaign***

|  | **Leader**  | **Date** | **Event**  | **Tweet** | **No. of Likes**  | **No. of Retweets** |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| 1. | Shorten | 16 May | the death of former Labor Prime Minister, Bob Hawke | ![hawke](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/hawke.png) |  13,629 | 2,986 |
| 2. | Shorten | 7 May | the condemnation of a [Daily Telegraph](https://www.dailytelegraph.com.au/news/nsw/labor-leader-bill-shortens-heartfelt-story-about-his-mother-was-missing-one-vital-fact/news-story/eeab8c4d16e3f55304e06eaa704699c9) front-page article headlined *"Mother of Invetion"* which accused Shorten of neglecting to tell the full story about his mum  | ![mum](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/mum.png) | 7,448 |  1,835 |
| 3. | Shorten | 4 May | during the second leaders' debate, Shorten accused Morrison of being a 'classic space invader' *(Source: [ABC News, 03-May-19](https://www.abc.net.au/news/2019-05-03/bill-shorten-accuses-scott-morrison-of-being-a/11079416?nw=0))* | ![spaceinvaders](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/spaceinvaders.png) | 6,718 | 1,348 |
| 4. | Shorten | 18 May | Election Day | ![change](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/change.png) | 5,936 | 875 |
| 5. | Shorten | 17 May | the death of former Labor Prime Minister, Bob Hawke | ![bob](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/bob.png) | 5,678 | 878 |
| 6. | Shorten | 17 May | one day before Election Day | ![chaos](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/chaos.png) | 4,105 | 884 |
| 7. | Morrison | 16 May | the death of former Labor Prime Minister, Bob Hawke | ![hawke1](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/hawke1.png) | 4,155 | 565 |
| 8. | Shorten | 11 May | one week before Election Day | ![abc](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/abc.png) | 3,603 | 1,029 |
| 9. | Morrison | 7 May | Morrison helped an older lady up after she been knocked over during an incident involving a protester attempting to egg the Prime Mininster *(Source: [ABC News, 8-May-19](https://www.abc.net.au/news/2019-05-07/scott-morrison-egged-on-federal-election-campaign-trail/11087174?nw=0))*  | ![albury](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/albury.png) | 3,840 | 593 |
| 10. |  Shorten | 15 May | former Labor Prime Minister, Bob Hawke, endorces Shorten *(Source: [David Crowe, The Age, 15-May-19](https://www.theage.com.au/federal-election-2019/hawke-backs-shorten-as-consensus-leader-in-new-open-letter-20190514-p51nbm.html))* | ![bob1](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/bob1.png) | 3,579 | 820 |


The following plots shows the spread of likes and retweets.

![EngagementsPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/EngagementsPlot.png)




## Analysing the Data
#### Sentiment Analysis

*NB. This is yet to be completed*



#### Performance

*NB. This is yet to be completed*


## Credits
Includes code inspired and adapted from the following sources:

- [David Robinson's Text Analysis of Trump's tweets](http://varianceexplained.org/r/trump-tweets/)

- [Drew Conway's Comparative Cloud](https://sites.google.com/site/miningtwitter/questions/talking-about/wordclouds/modified-cloud)