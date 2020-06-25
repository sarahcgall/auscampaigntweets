# 2019 Australian Federal Election Campaign Tweets
This is an analysis of tweets by the Prime Minister of Australia, Scott Morrison MP, and the then-Leader of the Opposition, Bill Shorten MP, during the 2019 Australian Federal Election.

| ![morrison](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/morrison.png)  | ![shorten](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/shorten.png) |
| ------------- | ------------- |
| [\@ScottMorrisonMP](http://www.twitter.com/ScottMorrisonMP)| [\@billshortenmp](http://www.twitter.com/billshortenmp)|
| 394,821 followers | 345,761 followers |
| Liberal Party :large_blue_circle: | Labor Party :red_circle: |


#### Content
This analysis is a work in progress and currently includes the following:

***Tweet Engagement***

- [X] **Engagement:** Number of 'likes' and 'retweets'.
- [ ] **Performance:** Analysis of the types of tweets that performed the best against the metric of engagements (likes and retweets).

***Tweet Dates, Times & Sources***

- [X] **Dates:** Number of tweets per day during the campaign.
- [X] **Days:** Average number of tweets per day of the week.
- [X] **Devices:** Proportion of tweets at each hour of the day by device used.


***Tweet Content***

- [ ] **Content:** Content included in tweets such as photos and URLs.
- [ ] **Emojis, Hashtags & Mentions**
- [X] **Types:** Ratio of the types of tweets.
- [ ] **Character Length**
- [X] **Word Frequency:** Most used words and the frequency words in tweets.
- [ ] **Sentiment:** Analysis of sentiment of tweets.



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


***Variables included:*** name of the leader (`MP`); the date and time tweeted (`created_at`, `date`, `day` & `hour`); the text of the tweet (`text`); the device used to tweet (`source`); the character length of the tweet (`display_text_width`); the type of tweet - original, reply, quote, or retweet (`type`); number of likes (`favorite_count`); number of retweets (`retweet_count`); total number of likes and retweets (`total_count`); hashtags used (`hashtags`); the link used (`urls_expanded_url`); the photo used (`media_expanded_url` & `media_type`); mentions used (`mentions_screen_name`); information about quoted tweets and retweets (`qr_favorite_count`, `qr_retweet_count`, `qr_screen_name` & `qr_followers_count`).



## Tweet Engagement
In order to analyse engagement of each leaders' tweets, the data was filtered to remove all retweets and therefore only included, organic tweets, quotes and replies.

Overall, Shorten's tweets received a total of 231,295 likes and retweets (*likes = 178,774, retweets = 52,521*) compared to Morrison's tweets which received a total of 71,912 likes and retweets (*likes = 60,855; retweets = 11,057*). This overall engagement demonstrates Shorten's dominance over Morrison. 

The following plot shows the frequency of each leaders' total engagement (likes & tweets) per tweet per day.

![TotalPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/TotalPlot.png)


Morrison had an average of 503 likes and 91 retweets per tweet. Likes and retweets per tweet ranged from a minimum 97 likes and 9 retweets to 4,155 likes and 593 retweets. Shorten had an average of 1097 likes and 322 retweets per tweet. Likes and retweets per tweet ranged from a minimum of 85 likes and 34 retweets to 13,629 likes and 2,986 retweets. 

The following plots shows the spread of likes and retweets.

![EngagementsPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/EngagementsPlot.png)


A number of outliers related to key events during the campaign, most notedbly the death of former Labor Prime Minister, Bob Hawke. The top 10 tweets during the campaign highlight these key events.

***Top 10 tweets during the campaign***

|  |**Tweet**  | **Prompting Event** | **No. of Likes**  | **No. of Retweets** |
| :-----------: | :-----------: | :------------ | :-----------: | :-----------: |
| 1. | ![hawke](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/hawke.PNG) | the death of former Labor Prime Minister, Bob Hawke |  13,629 | 2,986 |
| 2. |  ![mum](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/mum.PNG) | the condemnation of a [Daily Telegraph](https://www.dailytelegraph.com.au/news/nsw/labor-leader-bill-shortens-heartfelt-story-about-his-mother-was-missing-one-vital-fact/news-story/eeab8c4d16e3f55304e06eaa704699c9) front-page article headlined *"Mother of Invetion"* which accused Shorten of neglecting to tell the full story about his mum | 7,448 |  1,835 |
| 3. | ![spaceinvaders](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/spaceinvaders.PNG) | during the second leaders' debate, Shorten accused Morrison of being a 'classic space invader' *(Source: [ABC News, 03-May-19](https://www.abc.net.au/news/2019-05-03/bill-shorten-accuses-scott-morrison-of-being-a/11079416?nw=0))* | 6,718 | 1,348 |
| 4. | ![change](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/change.PNG) | Election Day | 5,936 | 875 |
| 5. | ![bob](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/bob.PNG) | the death of former Labor Prime Minister, Bob Hawke | 5,678 | 878 |
| 6. | ![chaos](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/chaos.PNG) | one day before Election Day | 4,105 | 884 |
| 7. | ![hawke1](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/hawke1.PNG) | the death of former Labor Prime Minister, Bob Hawke | 4,155 | 565 |
| 8. | ![abc](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/abc.PNG) | one week before Election Day | 3,603 | 1,029 |
| 9. | ![albury](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/albury.PNG) | Morrison helped an older lady up after she been knocked over during an incident involving a protester attempting to egg the Prime Mininster *(Source: [ABC News, 8-May-19](https://www.abc.net.au/news/2019-05-07/scott-morrison-egged-on-federal-election-campaign-trail/11087174?nw=0))* | 3,840 | 593 |
| 10. | ![bob1](https://github.com/sarahcgall/auscampaigntweets/blob/master/tweets/bob1.PNG) | former Labor Prime Minister, Bob Hawke, endorces Shorten *(Source: [David Crowe, The Age, 15-May-19](https://www.theage.com.au/federal-election-2019/hawke-backs-shorten-as-consensus-leader-in-new-open-letter-20190514-p51nbm.html))* | 3,579 | 820 |


## Tweet Dates, Times & Sources
In order to analyse the days and dates of when each leader tweeted, missing dates were added and assigned a 0 to complete the date range.

#### Dates
Over the entire 38 day campaign, Shorten and Morrison tweeted on average 4 and 3 tweets per day, respectively (*Shorten = 4.289; Morrison = 3.447*). Morrison tweeted between 0 and 18 tweets in any given day with the maximum occurring on the 12th of May, 5 days before election day. Other notable peaks occurred during the media blackout period on the 16th of May (*n = 9 tweets*), on the day that early voting commenced on the 29th of April (*n = 9 tweets*), and just before the close of the electoral rolls on the 16th of April (*n = 9 tweets*).


Shorten tweeted between 0 and 10 tweets in any given day with the maximum occurring on the 14th of May, 3 days before election day. Shorten tweeted between 1 and 10 tweets over the campaign period. Other notable peaks occurred on the 22nd, 24th and 26th of April (*n = 9, 8 & 8 tweets, respectively*), the week between Easter Sunday and Anzac Day (two days which campaigning was paused). During this week, Shorten campaigned in the ultra-marginal seats of Herbert (Townsville) and Leichhardt (Cairns). On the 22nd of April, both leaders also responded to the devastating Easter Sunday bombings in Sri Lanka, which killed more than 250 people, including two Australians.


Both leaders did not tweet on Good Friday (19 April) which was a campaign truce day. In addition to this, Morrison did not tweet on six other days. On these days, Morrison was:

- campaigning in Sydney where he announced more than $42 million for mental health services for young and indigenous people (*Source: [Matt Coughlan, The Canberra Times, 13/04/19](https://www.canberratimes.com.au/story/6042641/morrison-pledges-42m-mental-health-boost/?cs=14231#gsc.tab=0)*);
- campaigning in the marginal seat of Chisholm in Melbourne where he focused on the government's good economic record including tax relief for small businesses (*Source: [Bo Seo, AFR, 15/04/19](https://www.afr.com/politics/federal-election-2019-live-battle-for-victoria-20190415-h1dhej)*);
- campaigning in the Labor-held seats of Braddon and Lyons in regional Tasmania where he announced $100 million for an irrigation scheme (*Source: [Liz Main, AFR, 17/04/19](https://www.afr.com/politics/federal/federal-election-2019-live-pm-in-tassie-shorten-in-wa-20190417-h1dk9c)*);
- campaigning in Brisbane where he announced $100 million for cancer and mental health services in Queensland (*Source: [The Recorder, 04/05/19](https://www.portpirierecorder.com.au/story/6105733/day-24-of-the-federal-election-campaign/)*);
- campaigning in the regional New South Wales seat of Cowper where he focused on the government's good economic record (*Source: [Tim Boyd, AFR, 09/05/19](https://www.afr.com/politics/federal/federal-election-2019-live-final-leaders-debate-wash-up-20190509-h1e849)*); and
- campaigning in the marginal seat of Boothby in Adelaide where he focused on first home buyers (*Source: [Elouise Fowler, AFR, 14/05/19](https://www.afr.com/politics/federal/federal-election-2019-live-pm-and-shorten-target-marginals-on-day-34-20190514-h1edhs)*).


The following plot shows the number of tweets per day by each leader over the course of the campaign. It also includes key campaign milestones and public holidays in which both leaders agreed to a campaign truce.

![DatesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DatesPlot.png)


#### Day of the week
On average, Shorten tweeted 4.37 times per day ranging from the most on Tuesdays (*mean = 6.2*) and the least on Saturdays (*mean = 2.67*). On avergae, Morrison tweeted 3.5 times per day ranging from the most on Sundays (*mean = 6.4*) and the least on Wednesdays (*mean = 1.2*). 


The following plot shows the average numer of tweets per day of the week by each leader of the course of the campaign. 

![DaysPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DaysPlot.png)


#### Devices & hour of the day
The majority of the leaders' tweets came from TweetDeck (*Shorten = 70 (42.9%); Morrison = 30 (22.9%)*) and an iPhone (*Shorten = 49 (30.1%); Morrison = 91 (69.5%)*). The minority came from a Twitter Web Client (*Shorten = 1 (0.6%); Morrison = 10 (7.6%)*). Shorten was the only leader to utilise Periscope (*Shorten = 43 (26.4%)*) during the campaign which he utilised to live-stream his press conferences. 

Tweets from Shorten's iPhone was most likely to occur at 8am (*16.3% of tweets*) and 6pm (*12.3% of tweets*). Tweets from TweetDeck were most likely to occur at 7am (*18.6% of tweets*), between 4pm and 5pm (*14.3% of tweets & 12.9% of tweets, respectively*), and at 7pm (*11.4% of tweets*) after the nightly news. Shorten streamed his morning press conferences via Periscope between 10am and 12pm (*10am = 16.3%; 11am = 32.6%; 12pm = 25.6%*).

Tweets from Morrison's iPhone was most likely to occur at 9am (*11% of tweets*) and 2pm (*13.2% of tweets*). Tweets from TweetDeck were most likely to occur at between 11am and 12pm (*23.3% of tweets & 20% of tweets, respectively*), at 4pm (*10% of tweets*), and between 6pm and 7pm (*10% of tweets & 13.3% of tweets, respectively*). Tweets from a Twitter Web Client generally occurred between 10am and 12pm (*10am = 30%; 11am = 10%; 12pm = 40%*).

The following plot shows the proportion of tweets at each hour of the day by device by each leader. 

![DevicesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/DevicesPlot.png)



## Tweet Content
In order to analyse the content of each leaders' tweets, the data was cleaned and stored in a dataframe, `summary`. This process included: 

1. Identifying photos and videos from the `media_expanded_url` variable and splitting them into two new variables, `photo` and `video`; 

2. Counting the numbers of photos, videos and urls (`url`) per tweet; and

3. Counting elements within nested variables, `hashtags`, `qr_screen_name` and `mentions_screen_name`, per tweet.


In order to analyse the emojis, hashtags and mentions of each leaders' tweets, the data was cleaned and stored in a dataframe, `qrmh`. This process included: 

1. Lengthening the data by unnesting variables, `emoji`, `mentions_screen_name`, `qr_screen_name`, and `hashtags`, contained in each individual tweet; 

2. Adding '@' and '#' signs in front of individual mentions and hashtags;

3. Merging variables into a new variable, `screen_name`; and

4. Creating a new variable, `type`, to state whether the the element is a emoji, hashtag or mention.


In total, Shorten's 163 tweets contained 

***Shorten's tweet content***

| **Content Type** | **Frequency**  | **Mean** | **Min**  | **Max** |
| :----------- | :-----------: | :-----------: | :-----------: | :-----------: |
| Character Length | 20,822 | 128 | 0 | 293 |
| Emojis | 14 | 0.09 | 0 | 5 |
| Hashtags | 5 | 0.03 | 0 | 2 |
| Mentions (organic) | 13 | 0.08 | 0 | 4 |
| Mentions (quote & retweets) | 3 | 0.02 | 0 | 1 |
| URLs | 71 | 0.4 | 0 | 1 |
| Photos | 45 | 0.3 | 0 | 1 |
| Videos | 32 | 0.2 | 0 | 1 |

In total, Morrison's 131 tweets contained 

***Morrison's tweet content***

| **Content Type** | **Frequency**  | **Mean** | **Min**  | **Max** |
| :----------- | :-----------: | :-----------: | :-----------: | :-----------: |
| Character Length | 26,521 | 202 | 22 | 300 |
| Emojis | 7 | 0.05 | 0 | 2  |
| Hashtags | 51 | 0.4 | 0 |  4 |
| Mentions (organic) | 46 | 0.4 | 0 | 2 |
| Mentions (quote & retweets) | 13 | 0.1 |  0  | 2  |
| URLs | 7 | 0.05 | 0 | 1 |
| Photos | 50 | 0.4 | 0 | 1 |
| Videos | 15 | 0.1 | 0 | 1 |


#### Emojis, Hashtags & Mentions

*NB. This is yet to be completed*


#### Types
Throughout the entirety of the campaign, Shorten tweeted 163 times and Morrison tweeted 131 times. These tweets consisted of organic tweets (*Shorten = 148 (90.8%); Morrison = 93 (71.0%)*), replies to tweets (*Shorten = 12 (7.4%); Morrison = 25 (19.1%)*), quotes (*Shorten = 3 (1.8%); Morrison = 3 (2.3%)*), and retweets (*Shorten = 0 (0.0%); Morrison = 10 (7.6%)*). All replies were to each leaders' own tweets (i.e. threads).

The following plot shows the ratio of organic tweets, replies, quotes and retweets by each leader.

![TypesPlot](https://github.com/sarahcgall/auscampaigntweets/blob/master/figs/TypesPlot.png)


#### Character Length

*NB. This is yet to be completed*


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


#### Sentiment Analysis

*NB. This is yet to be completed*


## Credits
Includes code inspired and adapted from the following sources:

- [David Robinson's Text Analysis of Trump's tweets](http://varianceexplained.org/r/trump-tweets/)

- [Drew Conway's Comparative Cloud](https://sites.google.com/site/miningtwitter/questions/talking-about/wordclouds/modified-cloud)