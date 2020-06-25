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
library(gghighlight)
library(rvest)

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
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone"),
         created_at = with_tz(created_at, "Australia/Sydney"),
         date = date(created_at),
         day = wday(date, label = TRUE, abbr = FALSE),
         hour = hour(created_at),
         is_reply = ifelse(!is.na(reply_to_screen_name), "Reply", NA),
         is_quote = ifelse(is_quote == "TRUE", "Quote", NA),
         is_retweet = ifelse(is_retweet == "TRUE", "Retweet", NA),
         total_count = favorite_count + retweet_count) %>%
  unite("type", is_reply, is_quote, is_retweet, sep = "", na.rm = FALSE) %>%
  mutate(type = str_replace_all(type, "NA", ""),
         type = str_replace(type, "^$", "Organic")) %>%
  unite("qr_favorite_count", quoted_favorite_count, retweet_favorite_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_favorite_count = str_replace_all(qr_favorite_count, "NA", "")) %>%
  unite("qr_retweet_count", quoted_retweet_count, retweet_retweet_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_retweet_count = str_replace_all(qr_retweet_count, "NA", "")) %>%
  unite("qr_screen_name", quoted_screen_name, retweet_screen_name, sep = "", na.rm = FALSE) %>%
  mutate(qr_screen_name = str_replace_all(qr_screen_name, "NA", "")) %>%
  mutate(qr_screen_name = paste0(ifelse(qr_screen_name != "", "@", ""), qr_screen_name)) %>%
  unite("qr_followers_count", quoted_followers_count, retweet_followers_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_followers_count = str_replace_all(qr_followers_count, "NA", "")) %>%
  mutate(MP = "Bill Shorten MP") %>%
  select(MP,created_at,date,day,hour,text,source,display_text_width,type,reply_to_screen_name,favorite_count,retweet_count,total_count,hashtags,urls_expanded_url,media_expanded_url,media_type,mentions_screen_name,qr_favorite_count,qr_retweet_count,qr_screen_name,qr_followers_count) %>%
  arrange(created_at)


#Morrison Campaign Data
morrison_campaign <- morrison %>%
  filter(created_at >= ymd("2019-04-11") &
           created_at < ymd("2019-05-18")) %>%
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone")) %>%
  mutate(created_at = (with_tz(created_at, "Australia/Sydney"))) %>%
  mutate(date = date(created_at)) %>%
  mutate(day = wday(date, label = TRUE, abbr = FALSE)) %>%
  mutate(hour = hour(created_at)) %>%
  mutate(is_reply = ifelse(!is.na(reply_to_screen_name), "Reply", NA)) %>%
  mutate(is_quote = ifelse(is_quote == "TRUE", "Quote", NA)) %>%
  mutate(is_retweet = ifelse(is_retweet == "TRUE", "Retweet", NA)) %>%
  mutate(total_count = favorite_count + retweet_count) %>%
  unite("type", is_reply, is_quote, is_retweet, sep = "", na.rm = FALSE) %>%
  mutate(type = str_replace_all(type, "NA", "")) %>%
  mutate(type = str_replace(type, "^$", "Organic")) %>%
  unite("qr_favorite_count", quoted_favorite_count, retweet_favorite_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_favorite_count = str_replace_all(qr_favorite_count, "NA", "")) %>%
  unite("qr_retweet_count", quoted_retweet_count, retweet_retweet_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_retweet_count = str_replace_all(qr_retweet_count, "NA", "")) %>%
  unite("qr_screen_name", quoted_screen_name, retweet_screen_name, sep = "", na.rm = FALSE) %>%
  mutate(qr_screen_name = str_replace_all(qr_screen_name, "NA", "")) %>%
  mutate(qr_screen_name = paste0(ifelse(qr_screen_name != "", "@", ""), qr_screen_name)) %>%
  unite("qr_followers_count", quoted_followers_count, retweet_followers_count, sep = "", na.rm = FALSE) %>%
  mutate(qr_followers_count = str_replace_all(qr_followers_count, "NA", "")) %>%
  mutate(MP = "Scott Morrison MP") %>%
  select(MP,created_at,date,day, hour,text,source,display_text_width,type,reply_to_screen_name,favorite_count,retweet_count,total_count,hashtags,urls_expanded_url,media_expanded_url,media_type,mentions_screen_name,qr_favorite_count,qr_retweet_count,qr_screen_name,qr_followers_count) %>%
  arrange(created_at)

#Combined Leaders Campaign Data
leaders_campaign <- bind_rows(shorten_campaign, morrison_campaign)
#============================================================#


#============================================================#
##                       TWEET ENGAGEMENT
#============================================================#
#Summary Statistics
leaders_campaign %>% filter(MP == "Bill Shorten MP" & type != "Retweet") %>% select(favorite_count, retweet_count, total_count) %>% count(sum(total_count),sum(retweet_count),sum(favorite_count))
leaders_campaign %>% filter(MP == "Bill Shorten MP" & type != "Retweet") %>% select(favorite_count, retweet_count, total_count) %>% summary(total_count)
leaders_campaign %>% filter(MP == "Bill Shorten MP" & type != "Retweet") %>% select(date, favorite_count, retweet_count, total_count, text) %>% arrange(desc(total_count))

leaders_campaign %>% filter(MP == "Scott Morrison MP" & type != "Retweet") %>% select(favorite_count, retweet_count, total_count) %>% count(sum(total_count),sum(retweet_count),sum(favorite_count))
leaders_campaign %>% filter(MP == "Scott Morrison MP" & type != "Retweet") %>% select(favorite_count, retweet_count, total_count) %>% summary(total_count)
leaders_campaign %>% filter(MP == "Scott Morrison MP" & type != "Retweet") %>% select(date, favorite_count, retweet_count, total_count, text) %>% arrange(desc(total_count))

#Create Plot: TotalPlot
leaders_campaign %>% 
  filter(type != "Retweet") %>% 
  select(MP, date, total_count) %>%
  ggplot(aes(date, total_count, fill = MP, colour = total_count)) +
  geom_bar(stat = "identity", position = "stack", alpha = 0.7, colour = "grey90") +
  geom_vline(xintercept = as.Date("2019-05-18"), colour = "purple4", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-11"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-18"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-29"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-25"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-19"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-04-21"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_vline(xintercept = as.Date("2019-05-15"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  scale_y_continuous(limits = c(0,NA), expand = c(0,1000)) +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  labs(x="Date", 
       y="Total engagement", 
       title = "Number of engagements (likes & retweets) per tweet per day",
       fill = "MP") +
  facet_grid(row = vars(MP)) +
  gghighlight(label_key = MP, use_direct_label = FALSE) +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 18, family = "Calibri Light", hjust = 0.5, vjust = 3),
    axis.title = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light"),
    strip.text.y = element_blank()
  )


#Create Plot: EngagementsPlot
#Likes - normal scale
like_normal <- leaders_campaign %>%
  filter(type != "Retweet") %>% 
  select(MP, type, favorite_count) %>%
  ggplot(aes(MP, favorite_count, fill = MP)) +
  geom_boxplot(outlier.colour = "black", alpha = 0.7) +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  labs(title = "No. of Likes",
       y = "No. of likes",
       fill = "MP") +
  facet_wrap(~type, strip.position="bottom") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 13, family = "Calibri Light", hjust = 0.5),
    axis.title.y = element_blank(),
    axis.text.y = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light")
  )

#Likes - log10 scale
like_log <- leaders_campaign %>%
  filter(type != "Retweet") %>% 
  select(MP, type, favorite_count) %>%
  ggplot(aes(MP, favorite_count, fill = MP)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_y_log10() +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  labs(title = "No. of Likes (log10 scale)",
       y = "No. of likes (log10)",
       fill = "MP") +
  facet_wrap(~type, strip.position="bottom") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 13, family = "Calibri Light", hjust = 0.5),
    axis.title.y = element_blank(),
    axis.text.y = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light")
  )


#Retweets - normal scale
retweet_normal <- leaders_campaign %>%
  filter(type != "Retweet") %>% 
  select(MP, type, retweet_count) %>%
  ggplot(aes(MP, retweet_count, fill = MP)) +
  geom_boxplot(outlier.colour = "black", alpha = 0.7) +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  labs(title = "No. of Retweets",
       y = "No. of retweets",
       fill = "MP") +
  facet_wrap(~type, strip.position="bottom") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 13, family = "Calibri Light", hjust = 0.5),
    axis.title.y = element_blank(),
    axis.text.y = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light")
  )

#Retweets - log10 scale
retweet_log <- leaders_campaign %>%
  filter(type != "Retweet") %>% 
  select(MP, type, retweet_count) %>%
  ggplot(aes(MP, retweet_count, fill = MP)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.7) +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_y_log10() +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  labs(title = "No. of Retweets (log10 scale)",
       y = "No. of retweets",
       fill = "MP") +
  facet_wrap(~type, strip.position="bottom") +
  theme(
    plot.margin = margin(1,1,1,1, "cm"),
    plot.background = element_rect(
      fill = "white"
    ),
    plot.title = element_text(face = "plain", size = 13, family = "Calibri Light", hjust = 0.5),
    axis.title.y = element_blank(),
    axis.text.y = element_text(face = "plain", size = 10, family = "Calibri Light"),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.title = element_text(face = "plain", size = 11, family = "Calibri Light"),
    legend.text = element_text(face = "plain", size = 10, family = "Calibri Light")
  )

engagementplot <- ggarrange(like_normal, like_log, retweet_normal, retweet_log, heights = c(2, 2), ncol = 2, nrow = 2, align = "h", common.legend = TRUE, legend = "bottom")
engagementplot <- annotate_figure(engagementplot,
                                  top = text_grob("Tweet Engagement", vjust = 1, face = "plain", size = 18, family = "Calibri Light")) 

#============================================================#



#============================================================#
##               TWEET DATES, TIMES & SOURCES
#=========================DATES==============================#
#Summary statistics
leaders_campaign %>% select(MP, date) %>% count(MP, date) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% arrange(desc(n))
leaders_campaign %>% select(MP, date, day) %>% count(MP, date, day) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% mutate(day = wday(date, label = TRUE, abbr = FALSE)) %>% filter(n == 0) %>% arrange(desc(date))
leaders_campaign %>% filter(MP == "Bill Shorten MP") %>% select(MP, date) %>% count(MP, date) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% summary(n)
leaders_campaign %>% filter(MP == "Scott Morrison MP") %>% select(MP, date) %>% count(MP, date) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% summary(n)
leaders_campaign %>% filter(MP == "Bill Shorten MP" & date == "2019-04-22") %>% select(text)

#Create plot: Number of tweets per day
leaders_campaign %>%
  select(MP, date) %>%
  count(MP, date) %>%
  group_by(MP) %>%
  complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>%
  ungroup() %>%
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
  scale_y_continuous(limits = c(0, 22), expand = c(0,0)) +
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


#==========================DAYS==============================#
#Summary statistics
leaders_campaign %>% select(MP, day, date) %>% count(MP, day, date) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% mutate(day = wday(date, label = TRUE, abbr = FALSE)) %>% group_by(MP, day) %>% summarise(mean(n)) %>% group_by(MP) %>% summarise(mean(`mean(n)`))
leaders_campaign %>% select(MP, day, date) %>% count(MP, day, date) %>% group_by(MP) %>% complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% ungroup() %>% mutate(day = wday(date, label = TRUE, abbr = FALSE)) %>% group_by(MP, day) %>% summarise(mean(n))

#Create plot: DaysPlot - Average number of tweets per day of week
leaders_campaign %>% 
  select(MP, day, date) %>% 
  count(MP, day, date) %>% 
  group_by(MP) %>% 
  complete(date = seq.Date(from = ymd("2019-04-11"), to = ymd("2019-05-18"), by="day"), fill = list(n = 0)) %>% 
  ungroup() %>% 
  mutate(day = wday(date, label = TRUE, abbr = FALSE)) %>% 
  group_by(MP, day) %>% 
  summarise(mean(n)) %>%
  ggplot(aes(day, `mean(n)`, fill = MP)) +
  geom_bar(stat="identity", position = "dodge", width = 0.7, alpha = 0.8) +
  scale_fill_manual(values = c("#EF3B2C","#4292C6")) +
  scale_y_continuous(limits = c(0, 8), expand = c(0,0)) +
  labs(x = "Day of week",
       y = "Average no. of tweets",
       title = "Average number of tweets per day of week",
       fill = "") +
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


#Create plot: DevicesPlot - Proportion of tweets tweeted at each hour for each device
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

#============================================================#




#============================================================#
##                     TWEET CONTENT
#============================================================#
#Clean - Extract all words from tweets, remove links to pictures, and remove stop words:
shorten_words <- shorten_campaign %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$") & type != "Retweet") %>%
  mutate(word = str_replace(word, "^'", ""))

morrison_words <- morrison_campaign %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$") & type != "Retweet") %>%
  mutate(word = str_replace(word, "^'", ""))


#Clean - 


#Clean - create emoji list and pattern for 
emoji <- readLines("https://unicode.org/Public/emoji/5.0/emoji-test.txt", encoding = "UTF-8") %>%
  str_subset(pattern = "^[^#]") %>%
  str_subset(pattern = ".+") %>% 
  str_split_fixed("; fully-qualified | ; non-fully-qualified", n = 2)
emoji <- as.data.frame(emoji)
emoji <- emoji %>%
  mutate(UNICODE = paste0(str_extract_all(V2, "# *\\S+"))) %>%
  mutate(Description = paste0(str_extract_all(V2, "#.*$"))) %>%
  select(UNICODE, Description) %>%
  mutate(Description = str_replace_all(Description, "# *\\S+", "")) %>%
  mutate(UNICODE = str_replace_all(UNICODE, "# *", "\\")) %>%
  mutate(UNICODE = str_replace_all(UNICODE, " $", "\\"))
emoji1 <- emoji %>% select(UNICODE) %>% mutate(word = UNICODE)

leader_emojis <- bind_rows(morrison_words, shorten_words) %>% select(word) %>% inner_join(emoji1)
pattern <- paste(leader_words$word, collapse = "|")


#Clean - totals of each content component (hashtags, emojis, mentions (organic), mentions (quotes & retweets), urls, photos, videos, cost)
summary <- leaders_campaign %>%
  select(MP, text, display_text_width, hashtags, qr_screen_name, mentions_screen_name, urls_expanded_url, media_expanded_url) %>%
  mutate(emoji = ifelse(grepl(pattern, text), str_extract_all(text, pattern), "0")) %>%
  mutate(emoji = as.numeric(ifelse(emoji != "0",lengths(emoji), "0"))) %>%
  mutate(photo = as.numeric(ifelse(grepl("photo",media_expanded_url), "1", "0"))) %>%
  mutate(video = as.numeric(ifelse(grepl("video",media_expanded_url), "1", "0"))) %>%
  mutate(url = as.numeric(ifelse(grepl("https://", urls_expanded_url), "1", "0"))) %>%
  mutate(hashtag = as.numeric(ifelse(!is.na(hashtags),lengths(hashtags), "0"))) %>%
  mutate(qr_mention = as.numeric(ifelse(qr_screen_name != "",lengths(qr_screen_name), "0"))) %>%
  mutate(mention = as.numeric(ifelse(!is.na(mentions_screen_name),lengths(mentions_screen_name), "0"))) %>%
  select(MP, display_text_width, emoji, hashtag, qr_mention, mention, url, photo, video)

#Summary Statistics
summary %>% filter(MP == "Bill Shorten MP") %>% select(display_text_width, emoji,hashtag,qr_mention,mention,url,photo,video) %>% summary(display_text_width)
summary %>% filter(MP == "Bill Shorten MP") %>% select(display_text_width,emoji,hashtag,qr_mention,mention,url,photo,video) %>% count(sum(display_text_width),sum(emoji),sum(hashtag),sum(qr_mention),sum(mention),sum(url),sum(photo),sum(video))
summary %>% filter(MP == "Scott Morrison MP") %>% select(display_text_width, emoji,hashtag,qr_mention,mention,url,photo,video) %>% summary(display_text_width) 
summary %>% filter(MP == "Scott Morrison MP") %>% select(display_text_width,emoji,hashtag,qr_mention,mention,url,photo,video) %>% count(sum(display_text_width),sum(emoji),sum(hashtag),sum(qr_mention),sum(mention),sum(url),sum(photo),sum(video))



#Clean - for wordcloud
qrmh <- leaders_campaign %>%
  select(MP, text, qr_screen_name, mentions_screen_name, hashtags) %>%
  mutate(emoji = ifelse(grepl(pattern, text), str_extract_all(text, pattern), "")) %>%
  select(MP, emoji, qr_screen_name, mentions_screen_name, hashtags) %>%
  unnest_wider(emoji, names_sep = "", names_repair = "unique") %>%
  unnest_wider(mentions_screen_name, names_sep = "", names_repair = "unique") %>%
  unnest_wider(hashtags, names_sep = "", names_repair = "unique") %>%
  mutate(mentions_screen_name...8 = paste0(ifelse(!is.na(mentions_screen_name...8), "@", ""), mentions_screen_name...8)) %>%
  mutate(mentions_screen_name...8 = str_replace_all(mentions_screen_name...8, "NA", "")) %>%
  mutate(mentions_screen_name...9 = paste0(ifelse(!is.na(mentions_screen_name...9), "@", ""), mentions_screen_name...9)) %>%
  mutate(mentions_screen_name...9 = str_replace_all(mentions_screen_name...9, "NA", "")) %>%
  mutate(mentions_screen_name...10 = paste0(ifelse(!is.na(mentions_screen_name...10), "@", ""), mentions_screen_name...10)) %>%
  mutate(mentions_screen_name...10 = str_replace_all(mentions_screen_name...10, "NA", "")) %>%
  mutate(mentions_screen_name...11 = paste0(ifelse(!is.na(mentions_screen_name...11), "@", ""), mentions_screen_name...11)) %>%
  mutate(mentions_screen_name...11 = str_replace_all(mentions_screen_name...11, "NA", "")) %>%
  mutate(hashtags...12 = paste0(ifelse(!is.na(hashtags...12), "#", ""), hashtags...12)) %>%
  mutate(hashtags...12 = str_replace_all(hashtags...12, "NA", "")) %>%
  mutate(hashtags...13 = paste0(ifelse(!is.na(hashtags...13), "#", ""), hashtags...13)) %>%
  mutate(hashtags...13 = str_replace_all(hashtags...13, "NA", "")) %>%
  mutate(hashtags...14 = paste0(ifelse(!is.na(hashtags...14), "#", ""), hashtags...14)) %>%
  mutate(hashtags...14 = str_replace_all(hashtags...14, "NA", "")) %>%
  mutate(hashtags...15 = paste0(ifelse(!is.na(hashtags...15), "#", ""), hashtags...15)) %>%
  mutate(hashtags...15 = str_replace_all(hashtags...15, "NA", "")) %>%
  unite("screen_name", emoji...2:hashtags...15,sep = ",", na.rm = FALSE) %>%
  mutate(screen_name = str_replace_all(screen_name, "NA", "")) %>%
  mutate(screen_name = str_split(screen_name, ",")) %>%
  unnest(screen_name) %>%
  filter(screen_name != "") %>%
  mutate(type = ifelse(grepl("@", screen_name), "mention", ifelse(grepl("#", screen_name), "hashtag", "emoji"))) %>%
  count(MP, screen_name, type)

#Summary Statistics
qrmh %>% filter(MP == "Bill Shorten MP") %>% arrange(desc(n))
qrmh %>% filter(MP == "Scott Morrison MP") %>% arrange(desc(n))

df <- summary %>% 
  filter(MP == "Bill Shorten MP") %>% 
  count(display_text_width = sum(display_text_width)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video)),
        emoji = (sum(emoji)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        hashtag = (sum(hashtag)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        qr_mention = (sum(qr_mention)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        mention = (sum(mention)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        url = (sum(url)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        photo = (sum(photo)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
        video = (sum(video)/(sum(display_text_width)+sum(emoji)+sum(hashtag)+sum(qr_mention)+sum(mention)+sum(url)+sum(photo)+sum(video))),
  ) %>%
  select(display_text_width,emoji,hashtag,qr_mention,mention,url,photo,video) %>%
  t() %>%
  as.data.frame() %>%
  rename(column0)

variable.names(df)


ggplot(aes(n)) + 
  geom_tile(color = "black", size = 0.5) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), trans = 'reverse') +
  scale_fill_brewer(palette = "Set3") +
  labs(title="Waffle Chart", subtitle="'Class' of vehicles",
       caption="Source: mpg") + 
  theme(panel.border = element_rect(size = 2),
        plot.title = element_text(size = rel(1.2)),
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        legend.position = "right")

#Create Wordcloud: QR, mentions & hashtags  
qrmh %>%
  ggplot(aes(label = screen_name, size = n, replace = TRUE, colour = MP)) +
  geom_text_wordcloud() +
  scale_size_area(max_size = 18) +
  scale_colour_manual(values = c("#EF3B2C","#4292C6")) +
  theme_minimal()

#=========================TYPE===============================#
#Summary statistics 
leaders_campaign %>% select(MP) %>% count(MP)
leaders_campaign %>% select(MP,type) %>% count(MP,type)
leaders_campaign %>% filter(type == "Reply") %>% select(MP, reply_to_screen_name) %>% count(MP, reply_to_screen_name) %>% arrange(desc(reply_to_screen_name))
leaders_campaign %>% select(MP, qr_screen_name) %>% count(MP, qr_screen_name) %>% arrange(desc(qr_screen_name))

#Create Plot: Devices - Total types of tweets
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


#======================WORD FREQUENCY==========================#
#Summary Statistics
nrow(shorten_words)
nrow(morrison_words)
shorten_words %>% count(word) %>% arrange(desc(n))
morrison_words %>% count(word) %>% arrange(desc(n))
shorten_words %>% count(word) %>% summary(n)
morrison_words %>% count(word) %>% summary(n)

#Prepare data for plot:
#Remove words less with frequency less than 4
shorten_wordcount <- shorten_words %>% count(word) %>%
  filter(!n <= 4)
morrison_wordcount <- morrison_words %>% count(word) %>%
  filter(!n <= 4)

#Join Morrison and Shorten df and determine difference in usage
wordcount_difference <- full_join(shorten_wordcount, morrison_wordcount, by = "word", suffix = c("shorten", "morrison")) %>%
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

#Create Plot: WordcloudPlot
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

#======================SENTIMENT==========================#
#Get sentiment words
nrc <- get_sentiments("nrc") %>%
  select(word, sentiment)

#For each word we want to know if it is more likely to come from Shorten or Morrison:
shorten_or <- shorten_words %>%
  select(word) %>%
  count(word) %>%
  transmute(word, Shorten = n)
morrison_or <- morrison_words %>%
  select(word) %>%
  count(word) %>%
  transmute(word, Morrison = n)
shorten_or_morrison <- full_join(shorten_or, morrison_or, by = "word") %>%
  mutate(Morrison = replace_na(Morrison, replace = 0), Shorten = replace_na(Shorten, replace = 0)) %>%
  mutate(or = (Morrison + 0.5) / (sum(Morrison) - Morrison + 0.5) / 
           ( (Shorten + 0.5) / (sum(Shorten) - Shorten + 0.5))) %>%
  left_join(nrc, by = "word") %>%
  mutate(sentiment = replace_na(sentiment, replace = "none"))

#Combine words and sentiments
morrisoncounts <- shorten_or_morrison %>%
  select(sentiment, Morrison) %>%
  count(sentiment) %>%
  rename(Morrison = n)
shortencounts <- shorten_or_morrison %>%
  select(sentiment,Shorten) %>%
  count(sentiment) %>%
  rename(Shorten = n)
sentiment_counts <- full_join(morrisoncounts,shortencounts, by = "sentiment")  

log_or <- sentiment_counts %>%
  mutate( log_or = log( (Morrison / (sum(Morrison) - Morrison)) / (Shorten / (sum(Shorten) - Shorten))),
          se = sqrt( 1/Morrison + 1/(sum(Morrison) - Morrison) + 1/Shorten + 1/(sum(Shorten) - Shorten)),
          conf.low = log_or - qnorm(0.975)*se,
          conf.high = log_or + qnorm(0.975)*se) %>%
  arrange(desc(log_or))

log_or %>%
  mutate(sentiment = reorder(sentiment, log_or),) %>%
  ggplot(aes(x = sentiment, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point(aes(sentiment, log_or)) +
  ylab("Log odds ratio for association between Morrison and sentiment") +
  coord_flip()

shorten_or_morrison %>%
  mutate(sentiment = factor(sentiment, levels = log_or$sentiment)) %>%
  mutate(log_or = log(or)) %>%
  filter(Morrison + Shorten > 10 & abs(log_or)>1) %>%
  mutate(word = reorder(word, log_or)) %>%
  ggplot(aes(word, log_or, fill = log_or < 0)) +
  facet_wrap(~sentiment, scales = "free_x", nrow = 2) + 
  geom_bar(stat="identity", show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

