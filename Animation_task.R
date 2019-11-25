library(ggplot2)
library(gganimate)
library(ggpubr)
theme_set(theme_minimal())

data <- read.csv("~/dev/Intro-R/germany.csv", header = T, sep = ",")
data$SchuldenProEW <- ((data$Gesamtschulden)/(data$Einwohner)) * 1000

p <- ggplot(data, aes(Jahr, SchuldenProEW)) +
  geom_line() +
  ylim(5, 30) +
  scale_x_continuous(breaks = seq(1990,2018,2)) +
  labs(x = "Year", y = "debt per inhabitant (Billion Euro)") + 
  theme(legend.position = "none")

p + geom_point(aes(group = seq_along(Jahr)), colour = "blue") +
  transition_reveal(Jahr)

t <- ggplot(data, aes(Jahr, Gesamtschulden)) +
  geom_line() + 
  ylim(400000,2100000) +
  scale_x_continuous(breaks = seq(1988,2018,2)) +
  labs(x = "Year", y = "total debt of Germany (Billion Euro)") + 
  theme(legend.position = "none")

t + geom_point(aes(group = seq_along(Jahr)), colour = "green") + 
  transition_reveal(Jahr)

e <- ggplot(data, aes(Jahr, Einwohner)) +
  geom_line() +
  ylim(78000000, 83000000) +
  scale_x_continuous(breaks = seq(1990,2018,2)) +
  labs(x = "Year", y = "German citicens") + 
  theme(legend.position = "none")

e + geom_point(aes(group = seq_along(Jahr)), colour = "purple") +
  transition_reveal(Jahr)
