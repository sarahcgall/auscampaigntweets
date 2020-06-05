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

#=========================SCRAPE=============================#
shorten <- get_timeline("@billshortenmp", n = 3200)
morrison <- get_timeline("@ScottMorrisonMP", n = 3200)


#=========================FILTER=============================#
#Filter for tweets during 2019 Australian Federal Election Campaign (between 11 April 2019 and 18 May 2019)
shorten_campaign <- shorten %>%
  filter(created_at >= ymd("2019-04-11") &
           created_at < ymd("2019-05-18")) %>%
  filter(!is_retweet) %>%
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone")) %>%
  mutate(hour = hour(with_tz(created_at, "Australia/Sydney"))) %>%
  arrange(created_at)

morrison_campaign <- morrison %>%
  filter(created_at >= ymd("2019-04-11") &
           created_at < ymd("2019-05-18")) %>%
  filter(!is_retweet) %>%
  mutate(source = str_replace(source, "Twitter for iPhone", "iPhone")) %>%
  mutate(hour = hour(with_tz(created_at, "Australia/Sydney"))) %>%
  arrange(created_at)

#=========================DATES=============================#
#Organise data
shorten_date <- shorten_campaign %>%
  select(created_at) %>%
  mutate(date = date(with_tz(created_at, "Australia/Sydney"))) %>%
  count(date) %>%
  mutate(MP = "Bill Shorten MP")
morrison_date <- morrison_campaign %>%
  select(created_at) %>%
  mutate(date = date(with_tz(created_at, "Australia/Sydney"))) %>%
  count(date) %>%
  mutate(MP = "Scott Morrison MP")
bothdates <- full_join(shorten_date, morrison_date, by = "date", suffix = c("shorten","morrison")) %>%
  mutate(MPmorrison = replace_na(MPmorrison, replace = "Scott Morrison MP"), nmorrison = replace_na(nmorrison, replace = 0)) %>%
  mutate(datemorrison = date)
shorten_date <- bothdates %>%
  select(date,nshorten,MPshorten) %>%
  transmute(date = date, n = nshorten, MP = MPshorten)
morrison_date <- bothdates %>%
  select(datemorrison,nmorrison,MPmorrison) %>%
  transmute(date = datemorrison, n = nmorrison, MP = MPmorrison)
bothdates <- bind_rows(morrison_date, shorten_date)

#Create plot: Number of tweets per day
dates <- bothdates %>%
  ggplot(aes(date, n, colour = MP)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = as.Date("2019-05-18"), colour = "purple4", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-05-18"), label = "2019 Australian Federal Election", y = 10), colour="purple4", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-11"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-11"), label = "Campaign Commences", y = 10), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-18"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-18"), label = "Close of electoral rolls", y = 10), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-29"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-29"), label = "Early Voting Commences", y = 10), colour="grey45", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-25"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-25"), label = "ANZAC Day", y = 10), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-19"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-19"), label = "Good Friday", y = 10), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-04-21"), colour = "indianred", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-04-21"), label = "Easter Sunday", y = 10), colour="indianred", angle=90, nudge_x = -0.4) +
  geom_vline(xintercept = as.Date("2019-05-15"), colour = "grey45", size = 0.5, linetype = "dashed", alpha = 0.8) +
  geom_text(aes(x = as.Date("2019-05-15"), label = "Media Blackout", y = 10), colour="grey45", angle=90, nudge_x = -0.4) +
  scale_colour_manual(values = c("#EF3B2C","#4292C6")) +
  scale_y_continuous(limits = c(0, NA), expand = c(0,1)) +
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
#Devices used to compose and upload Shorten and Morrison's tweets:
shorten_campaign %>% count(source) %>% arrange(desc(n))
morrison_campaign %>% count(source) %>% arrange(desc(n))

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

#=========================PERFORMANCE=============================#
#Most liked tweets:
shorten_campaign %>% arrange(desc(favorite_count))
morrison_campaign %>% arrange(desc(favorite_count))

#Most retweeted tweets:
shorten_campaign %>% arrange(desc(retweet_count))
morrison_campaign %>% arrange(desc(retweet_count))




#=========================CLEAN=============================#
#Extract all words from tweets, remove links to pictures, and remove stop words:
shorten_words <- shorten_campaign %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))

morrison_words <- morrison_campaign %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word & !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))


#=========================WORDS=============================#
#Most commonly used words:
shorten_wordcount <- shorten_words %>%
  count(word) %>%
  arrange(desc(n))

morrison_wordcount <- morrison_words %>%
  count(word) %>%
  arrange(desc(n))

#=========================WORDCLOUD=============================#
#Create a wordcloud of commonly used words
shorten_wordcloud <- head(shorten_wordcount, 52) %>%
  ggplot(aes(label = word, size = n, replace = TRUE)) +
  geom_text_wordcloud_area(color = "#e2363e") +
  scale_size_area(max_size = 26) +
  theme_minimal()

morrison_wordcloud <- head(morrison_wordcount, 45) %>%
  ggplot(aes(label = word, size = n, replace = TRUE)) +
  geom_text_wordcloud_area(color = "#154e9d") +
  scale_size_area(max_size = 26) +
  theme_minimal()

wordclouds <- ggarrange(morrison_wordcloud, shorten_wordcloud, heights = c(2, 2), ncol = 1, nrow = 2, align = "v")
wordclouds <- annotate_figure(wordclouds,
                top = text_grob("Top words used in tweets", face = "bold", size = 18))

#=========================WORDMAP=============================#
#Remove words less with frequency less than 4
shorten_wordcount1 <- shorten_wordcount %>%
  filter(!n <= 4)
morrison_wordcount1 <- morrison_wordcount %>%
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

