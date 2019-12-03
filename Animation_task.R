library(ggplot2)
library(gganimate)
library(ggpubr)
library(magick)
library(dplyr)
theme_set(theme_minimal())

data <- read.csv("~/dev/Intro-R/germany.csv", header = T, sep = ",")
data$SchuldenProEW <- ((data$Gesamtschulden)/(data$Einwohner)) * 1000
data$EW_p <- (data$Einwohner)/79365000
data$Schuld_p <- (data$Gesamtschulden)/538334

p <- ggplot(data, aes(Jahr, SchuldenProEW)) +
  geom_line() +
  ylim(5, 30) +
  scale_x_continuous(breaks = seq(1990,2018,2)) +
  labs(x = "Year", y = "debt per inhabitant (Billion Euro)") + 
  theme(legend.position = "none") + geom_point(aes(group = seq_along(Jahr)), colour = "blue") +
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


########################################

citizens_gif <- ggplot(data, aes(Jahr, EW_p)) +
  geom_line() +
  ylim(0.9,4) +
  scale_x_continuous(breaks = seq(1990,2018,2)) +
  labs(x = "Year", y = "German citicens, 1990 = 1") + 
  theme(legend.position = "none") + geom_point(aes(group = seq_along(Jahr)), colour = "blue") +
  transition_reveal(Jahr)

citizens_gif

anim_save("Ger_pop2")

debt_gif <- ggplot(data, aes(Jahr, Schuld_p)) +
  geom_line() +
  ylim(0.9,4) +
  scale_x_continuous(breaks = seq(1990,2018,2)) +
  labs(x = "Year", y = "total debt of Germany, 1990 = 1") + 
  theme(legend.position = "none") + geom_point(aes(group = seq_along(Jahr)), colour = "red") +
  transition_reveal(Jahr)

debt_gif

anim_save("Ger_debt2")

# must save these animations to get them appended to each other


citizens_mgif <- image_read("~/dev/Intro-R/Ger_pop2")
debt_mgif <- image_read("~/dev/Intro-R/Ger_debt2")

new_gif <- image_append(c(citizens_mgif[1], debt_mgif[1]))
for(i in 2:100){
  combined <- image_append(c(citizens_mgif[i], debt_mgif[i]))
  new_gif <- c(new_gif, combined)
}

new_gif   # tada, two gifs side by side
anim_save("Ger_combined")



