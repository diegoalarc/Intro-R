# 26.11. Best practice coding

# perfomance package
parallel
multidplyr

# profinling code snippets

profvis

# pipe commands, pipelining

df <- read.csv("~/dev/Intro-R/germany.csv", sep = ",")
df %>% 
  subset(Gesamtschulden > 1500000)

library(babynames)

babynames %>% filter(sex == "M", name == "Marius") %>%
  select(n) %>%
  sum

starwars %>% 
  filter(species == "Human", height >= 190) %>%   # find the tallest humans in the Star Wars Universe
  View()

## Spatial Plotting

install.packages("RStoolbox")
library(RStoolbox)

ggRGB(lsat, r = 3, g = 2, b = 1,stretch = "lin" )

# should have done a ggplot Map -.- 
