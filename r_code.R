#=========================LIBRARY============================#
library(rtweet)
library(tidytext)
library(ggpubr)
library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
library(RColorBrewer)
library(ggwordcloud)
library(sentimentr)
library(gridExtra)
library(ggpubr)
library(ggrepel)
library(extrafont)
library(broom)

set.seed(1, sample.kind="Rounding")
#============================================================#


#============================================================#
##           Data Collection, Processing and Cleaning
#=====================DATA COLLECTING========================#
#Scrape leaders tweets from timeline:
shorten <- get_timeline("@billshortenmp", n = 3200)
morrison <- get_timeline("@ScottMorrisonMP", n = 3200)

#=====================DATA CLEANING==========================#
#Filter for tweets during 2019 Australian Federal Election Campaign (between 11 April 2019 and 18 May 2019)
#Shorten Campaign Data
shorten_campaign <- shorten %>%
  filter(created_at >= ymd("2019-04-11") &
           created_at < ymd("2019-05-18")) %>%
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone")) %>%
  mutate(created_at = with_tz(created_at, "Australia/Sydney")) %>%
  mutate(date = date(created_at)) %>%
  mutate(hour = hour(created_at)) %>%
  mutate(is_reply = ifelse(!is.na(reply_to_screen_name), "Reply", NA)) %>%
  mutate(is_quote = ifelse(is_quote == "TRUE", "Quote", NA)) %>%
  mutate(is_retweet = ifelse(is_retweet == "TRUE", "Retweet", NA)) %>%
  unite("type", is_reply, is_quote, is_retweet, sep = "", na.rm = FALSE) %>%
  mutate(type = str_replace_all(type, "NA", "")) %>%
  mutate(type = str_replace(type, "^$", "Organic")) %>%
  unite("qr_favorite_count", quoted_favorite_count, retweet_favorite_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_favorite_count = str_replace_all(qr_favorite_count, "NA", "")) %>%
  unite("qr_retweet_count", quoted_retweet_count, retweet_retweet_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_retweet_count = str_replace_all(qr_retweet_count, "NA", "")) %>%
  unite("qr_name", quoted_name, retweet_name, sep = "", na.rm = FALSE) %>%
  mutate(qr_name = str_replace_all(qr_name, "NA", "")) %>%
  unite("qr_followers_count", quoted_followers_count, retweet_followers_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_followers_count = str_replace_all(qr_followers_count, "NA", "")) %>%
  mutate(MP = "Bill Shorten MP") %>%
  select(MP,created_at,date,hour,text,source,display_text_width,type,favorite_count,retweet_count,hashtags,urls_expanded_url,media_expanded_url,media_type,mentions_screen_name,qr_favorite_count,qr_retweet_count,qr_name,qr_followers_count) %>%
  arrange(created_at)

#Morrison Campaign Data
morrison_campaign <- morrison %>%
  filter(created_at >= ymd("2019-04-11") &
           created_at < ymd("2019-05-18")) %>%
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone")) %>%
  mutate(created_at = with_tz(created_at, "Australia/Sydney")) %>%
  mutate(date = date(created_at)) %>%
  mutate(hour = hour(created_at)) %>%
  mutate(is_reply = ifelse(!is.na(reply_to_screen_name), "Reply", NA)) %>%
  mutate(is_quote = ifelse(is_quote == "TRUE", "Quote", NA)) %>%
  mutate(is_retweet = ifelse(is_retweet == "TRUE", "Retweet", NA)) %>%
  unite("type", is_reply, is_quote, is_retweet, sep = "", na.rm = FALSE) %>%
  mutate(type = str_replace_all(type, "NA", "")) %>%
  mutate(type = str_replace(type, "^$", "Organic")) %>%
  unite("qr_favorite_count", quoted_favorite_count, retweet_favorite_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_favorite_count = str_replace_all(qr_favorite_count, "NA", "")) %>%
  unite("qr_retweet_count", quoted_retweet_count, retweet_retweet_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_retweet_count = str_replace_all(qr_retweet_count, "NA", "")) %>%
  unite("qr_name", quoted_name, retweet_name, sep = "", na.rm = FALSE) %>%
  mutate(qr_name = str_replace_all(qr_name, "NA", "")) %>%
  unite("qr_followers_count", quoted_followers_count, retweet_followers_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_followers_count = str_replace_all(qr_followers_count, "NA", "")) %>%
  mutate(MP = "Scott Morrison MP") %>%
  select(MP,created_at,date,hour,text,source,display_text_width,type,favorite_count,retweet_count,hashtags,urls_expanded_url,media_expanded_url,media_type,mentions_screen_name,qr_favorite_count,qr_retweet_count,qr_name,qr_followers_count) %>%
  arrange(created_at)

#Combined Leaders Campaign Data
leaders_campaign <- bind_rows(shorten_campaign, morrison_campaign)
#============================================================#


#============================================================#
##                 Visualising the Data
#=========================TYPE===============================#
#Summary statistics 
leaders_campaign %>% select(MP) %>% count(MP)
leaders_campaign %>% select(MP,type) %>% count(MP,type)

#Total types of tweets
shorten_type <- shorten_campaign %>%
  select(type) %>%
  count(type) %>%
  mutate(n = (n/sum(n)*100)) %>%
  mutate(label = paste0(str_trim(format(round(n, 1), nsmall = 1), "left"), "%")) %>%
  ggdonutchart("n", label = "label", lab.pos = "in", lab.font = "white", fill = "type", 
               colour = "white",
               palette = c("#99000D","#EF3B2C","#FC9272")) +
  labs(title = "Bill Shorten MP",
       fill = "Tweet Type") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 12, family = "Calibri Light", hjust = 0.5, vjust = -150),
    axis.title = element_blank(),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.position = "right"
  )

morrison_type <- morrison_campaign %>%
  select(type) %>%
  count(type) %>%
  mutate(n = (n/sum(n)*100)) %>%
  mutate(label = paste0(str_trim(format(round(n, 1), nsmall = 1), "left"), "%")) %>%
  ggdonutchart("n", label = "label", lab.pos = "in", lab.font = "white", fill = "type", 
               colour = "white",
               palette = c("#084594","#2171B5","#4292C6","#6BAED6")) +
  labs(title = "Scott Morrison MP",
       fill = "Tweet Type") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 12, family = "Calibri Light", hjust = 0.5, vjust = -150),
    axis.title = element_blank(),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.position = "right"
  )

typesplot <- ggarrange(shorten_type, morrison_type, heights = c(2, 2), ncol = 2, nrow = 1, align = "h", legend = "left")
typesplot <- annotate_figure(typesplot,
                top = text_grob("Ratio of types of tweet", vjust = 6, face = "plain", size = 18, family = "Calibri Light"))


#=========================DATES==============================#
#Summary statistics
leaders_campaign %>% filter(MP == "Scott Morrison MP") %>% select(date) %>% count(date) %>% summary(n)
leaders_campaign %>% filter(MP == "Scott Morrison MP") %>% select(date) %>% count(date) %>% arrange(desc(n))
leaders_campaign %>% filter(MP == "Bill Shorten MP") %>% select(date) %>% count(date) %>% summary(n)
leaders_campaign %>% filter(MP == "Bill Shorten MP") %>% select(date) %>% count(date) %>% arrange(desc(n))
leaders_campaign %>% filter(MP == "Bill Shorten MP" & date == "2019-04-22") %>% select(text)

#Create plot: Number of tweets per day
datesplot <- leaders_campaign %>%
  select(MP, date) %>%
  count(MP,date) %>%
  ggplot(aes(date, n, colour = MP)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = as.Date("2019-05-18"), colour = "purple4", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-05-18"), label = "2019 Australian Federal Election", y = 15), colour="purple4", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-11"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-11"), label = "Issue of writs", y = 15), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-18"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-18"), label = "Close of electoral rolls", y = 15), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-29"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-29"), label = "Early voting commences", y = 15), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-25"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-25"), label = "ANZAC Day", y = 15), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-19"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-19"), label = "Good Friday", y = 15), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-21"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-21"), label = "Easter Sunday", y = 15), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-05-15"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-05-15"), label = "Media blackout", y = 15), colour="grey45", angle=90, nudge_x = -0.4) +
  scale_colour_manual(values = c("#EF3B2C","#4292C6")) +
  scale_y_continuous(limits = c(1, 22), expand = c(0,1)) +
  labs(x = "Date",
       y = "No. of tweets",
       title = "Number of tweets per day",
       color = "") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 18, family = "Calibri Light", hjust = 0.5, vjust = 3),
    axis.title = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.justification = "left",
    text = element_text(size=5, family = "Calibri Light", face = "plain")
  )


#=========================DEVICE=============================#
#Summary statistics
shorten_campaign %>% count(source) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
morrison_campaign %>% count(source) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
shorten_campaign %>% filter(source == "iPhone") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
morrison_campaign %>% filter(source == "iPhone") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
shorten_campaign %>% filter(source == "TweetDeck") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
morrison_campaign %>% filter(source == "TweetDeck") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
shorten_campaign %>% filter(source == "Periscope") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))
morrison_campaign %>% filter(source == "Twitter Web Client") %>% count(hour) %>% mutate(n/sum(n)*100) %>% arrange(desc(n))


#Create plot: Proportion of tweets tweeted at each hour for each device
shorten_device <- shorten_campaign %>%
  count(source, hour) %>%
  group_by(source) %>%
  mutate(percent = n / sum(n)) %>%
  ungroup %>%
  filter(!source == "Twitter Web Client") %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = c("#99000D","#EF3B2C","#FC9272")) +
  scale_y_continuous(labels = percent_format(), limits = c(0,.5)) +
  scale_x_continuous(limits = c(1,23)) +
  labs(x = "Hour of day",
       y = "% of tweets",
       subtitle = "Bill Shorten MP",
       color = "") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.subtitle = element_text(face = "plain", size = 12, family = "Calibri Light"),
    axis.title = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.justification = "left"
  )

morrison_device <- morrison_campaign %>%
  count(source, hour) %>%
  group_by(source) %>%
  mutate(percent = n / sum(n)) %>%
  ungroup %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line() +
  geom_point() +
  scale_color_manual(values = c("#084594","#4292C6","#9ECAE1")) +
  scale_y_continuous(labels = percent_format(), limits = c(0,0.5)) +
  scale_x_continuous(limits = c(1,23)) +
  labs(x = "Hour of day",
       y = "% of tweets",
       subtitle = "Scott Morrison MP",
       color = "") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.subtitle = element_text(face = "plain", size = 12, family = "Calibri Light"),
    axis.title = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.justification = "left"
  )


devices <- ggarrange(morrison_device, shorten_device, heights = c(2, 2), ncol = 1, nrow = 2, align = "v", legend = "right")
devices <- annotate_figure(devices,
                top = text_grob("Proportion of tweets tweeted at each hour of the day by device", face = "plain", size = 18, family = "Calibri Light"))



#======================WORD FREQUENCY==========================#
#Clean - Extract all words from tweets, remove links to pictures, and remove stop words:
shorten_words <- shorten_campaign %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$") & type != "retweet") %>%
  mutate(word = str_replace(word, "^'", ""))

morrison_words <- morrison_campaign %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$") & type != "retweet") %>%
  mutate(word = str_replace(word, "^'", ""))
  

#Summary Statistics
nrow(shorten_words)
nrow(morrison_words)
shorten_words %>% count(word) %>% arrange(desc(n))
morrison_words %>% count(word) %>% arrange(desc(n))
shorten_words %>% count(word) %>% summary(n)
morrison_words %>% count(word) %>% summary(n)

#Wordcloud Plot:
#Remove words less with frequency less than 4
shorten_wordcount <- shorten_wordcount %>%
  filter(!n <= 4)
morrison_wordcount <- morrison_wordcount %>%
  filter(!n <= 4)

#Join Morrison and Shorten df and determine difference in usage
wordcount_difference <- full_join(shorten_wordcount1, morrison_wordcount1, by = "word", suffix = c("shorten", "morrison")) %>%
  mutate(nshorten = replace_na(nshorten, replace = 0), nmorrison = replace_na(nmorrison, replace = 0)) %>%
  mutate(difference = nshorten - nmorrison)

shorten1 <- subset(wordcount_difference, difference > 0)
morrison1 <- subset(wordcount_difference, difference < 0)
both1 <- subset(wordcount_difference, difference == 0)

#Create function for optimal spacing on plot
optimal.spacing <- function(spaces)
{
  if(spaces > 1) {
    spacing <- 1 / spaces
    if(spaces%%2 > 0) {
      lim = spacing * floor(spaces/2)
      return(seq(-lim, lim, spacing))
    }
    else {
      lim = spacing * (spaces-1)
      return(seq(-lim, lim, spacing*2))
    }
  }
  else {
    return(jitter(0, amount=0.3))
  }
}

#Apply and add optimal spacing to dfs
shorten_spacing = sapply(table(shorten1$difference),
                       function(x) optimal.spacing(x))

morrison_spacing = sapply(table(morrison1$difference),
                        function(x) optimal.spacing(x))

both_spacing = sapply(table(both1$difference),
                      function(x) optimal.spacing(x))

shorten_optim = rep(0, nrow(shorten1))
for(n in names(shorten_spacing)) {
  shorten_optim[shorten1$difference == as.numeric(n)] <- shorten_spacing[[n]]
}
shorten1 = transform(shorten1, Spacing=shorten_optim)

morrison_optim = rep(0, nrow(morrison1))
for(n in names(morrison_spacing)) {
  morrison_optim[morrison1$difference == as.numeric(n)] <- morrison_spacing[[n]]
}
morrison1 = transform(morrison1, Spacing=morrison_optim)

both1$Spacing = as.vector(both_spacing)

#Create plot
wordcloudplot <- ggplot(shorten1, aes(x=difference, y=Spacing)) +
  geom_text_repel(aes(label=word,
                colour=difference, size = nshorten/3), segment.color = 'transparent', alpha=0.8) +
  geom_text_repel(data=morrison1, aes(x=difference, y=Spacing,
                                label=word, color=difference, size = nmorrison/3), segment.color = 'transparent',
            alpha=0.8) +
  geom_text_repel(data=both1, aes(x=difference, y=Spacing,
                              label=word, color=difference),
            alpha=0.8) +
  scale_size(range=c(3,11)) +
  scale_colour_gradient(low = "#154e9d", high = "#e2363e", guide = "none") +
  scale_x_reverse(breaks=c(-43, 0, 43),
                     labels=c("More by Scott Morrison MP","Equal","More by Bill Shorten MP")) +
  expand_limits(x = -43) +
  scale_y_continuous(breaks=c(0), labels=c("")) +
  labs(x="", y="", title = "Top words used in tweets", size = "Word Frequency") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    axis.line.x = element_line(arrow = arrow(angle = 15, length = unit(.1, "inches"), ends = "both", type = "open"),
                               colour = "grey50"),
    axis.text = element_text(size = 10, family = "Calibri Light"),
    legend.position = "bottom",
    legend.text = element_blank(),
    legend.title = element_text(size = 12, family = "Calibri Light"),
    plot.title = element_text(size = 18, face = "plain", hjust = 0.5, vjust = 3, family = "Calibri Light")
    
  )



#=========================CONTENT=============================#
#Clean



#Create a wordcloud of commonly used words (NB. WORK IN PROGRESS)
head(shorten_wordcount, 52) %>%
  ggplot(aes(label = word, size = n, replace = TRUE)) +
  geom_text_wordcloud_area(color = "#e2363e") +
  scale_size_area(max_size = 26) +
  theme_minimal()

head(morrison_wordcount, 45) %>%
  ggplot(aes(label = word, size = n, replace = TRUE)) +
  geom_text_wordcloud_area(color = "#154e9d") +
  scale_size_area(max_size = 26) +
  theme_minimal()

ggarrange(morrison_wordcloud, shorten_wordcloud, heights = c(2, 2), ncol = 1, nrow = 2, align = "v")
annotate_figure(wordclouds,
                              top = text_grob("Top words used in tweets", face = "bold", size = 18))


#=========================ENGAGEMENT=============================#
#Clean


