# Whatsapp Textmining - examples at https://github.com/JBGruber/rwhatsapp

install.packages("rwhatsapp")

library(rwhatsapp)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(tidytext)
library(stopwords)

#read in chat

chat <- rwa_read("C:/Users/Sinja/Desktop/Schnuffi.txt")

# Number of msg per day
chat %>%
  mutate(day = date(time)) %>%
  count(day) %>%
  ggplot(aes(x = day, y = n)) +
  geom_bar(stat = "identity") +
  ylab("") + xlab("") +
  ggtitle("Messages per day") +
  theme_bw() + geom_smooth()

# Number of msg per author
chat %>%
  mutate(day = date(time)) %>%
  count(author) %>%
  ggplot(aes(x = reorder(author, n), y = n)) +
  geom_bar(stat = "identity") +
  ylab("") + xlab("") +
  coord_flip() +
  ggtitle("Number of messages") +
  theme_bw()

# Favorite Emojis by participant
chat %>%
  unnest(emoji) %>%
  count(author, emoji, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder(emoji, n), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y")  +
  ggtitle("Most often used emojis") +
  theme_bw()

# Most often used words
chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  count(author, word, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder_within(word, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Most often used words") +
  theme_bw()

# remove the stop words, we want nouns
remove <- c(stopwords(language = "de"),
            "ich",
            "das",
            "ja",
            "du",
            "und",
            "nicht",
            "net",
            "is",
            "gut",
            "mal",
            "schon",
            "jetz",
            "ne",
            "okay",
            "dass",
            "halt")

chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  filter(!word %in% remove) %>%
  count(author, word, sort = TRUE) %>%
  group_by(author) %>%
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder_within(word, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Most often used words") +
  theme_bw()

# important words using tf-idf 
chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  select(word, author) %>%
  filter(!word %in% remove) %>%
  mutate(word = gsub(".com", "", word)) %>%
  mutate(word = gsub("^gag", "9gag", word)) %>%
  count(author, word, sort = TRUE) %>%
  bind_tf_idf(term = word, document = author, n = n) %>%
  filter(n > 10) %>%
  group_by(author) %>%
  top_n(n = 6, tf_idf) %>%
  ggplot(aes(x = reorder_within(word, n, author), y = n, fill = author)) +
  geom_col(show.legend = FALSE) +
  ylab("") +
  xlab("") +
  coord_flip() +
  facet_wrap(~author, ncol = 2, scales = "free_y") +
  scale_x_reordered() +
  ggtitle("Important words using tf-idf by author") +
  theme_bw()

# lexical diversity of messages
chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  filter(!word %in% remove) %>%
  group_by(author) %>%
  summarise(lex_diversity = n_distinct(word)) %>%
  arrange(desc(lex_diversity)) %>%
  ggplot(aes(x = reorder(author, lex_diversity),
             y = lex_diversity,
             fill = author)) +
  geom_col(show.legend = FALSE) +
  scale_y_continuous(expand = (mult = c(0, 0, 0, 500))) +
  geom_text(aes(label = scales::comma(lex_diversity)), hjust = -0.1) +
  ylab("unique words") +
  xlab("") +
  ggtitle("Lexical Diversity") +
  theme_bw() +
  coord_flip()

# unique words of [Author]
o_words <- chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  filter(author != "Schnuffi") %>% 
  count(word, sort = TRUE) 

chat %>%
  unnest_tokens(input = text,
                output = word) %>%
  filter(author == "Schnuffi") %>% 
  count(word, sort = TRUE) %>% 
  filter(!word %in% o_words$word) %>% # only select words nobody else uses
  top_n(n = 6, n) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col(show.legend = FALSE) +
  ylab("") + xlab("") +
  coord_flip() +
  ggtitle("Unique words of Schnuffi") +
  theme_bw()

