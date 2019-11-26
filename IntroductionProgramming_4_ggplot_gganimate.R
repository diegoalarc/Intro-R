# plotting stuff   12.11.2019

# fun stuff 

install.packages("brickr") # not available for r 3.6.1
install.packages("rwhatsapp") # analyse you r conversations
install.packages("ggthemes")

setwd("F:/Eagle/Introduction_Programming/Scripts")
df <- read.csv("output.csv")

# using ggplot2 

library(ggplot2)
library(rayshader)
library(gganimate)
library(gifski)
library(transformr)
library(ggthemes)

x11()
x <-  data.frame(x=1, y=1, label ="ggplot2 introduction \n@ EAGLE")
ggplot(data=x, aes(x=x,y=y)) + geom_text(aes(label=label), size = 15)

x1 <- rnorm(1000,0,1)
x2 <- rnorm(1000,5,10)
x3 <- rep(c("catA","catB","catB","catC","catC","catC"),200)[1:1000]
x4 <- factor(rep(c("yes","no"),500))

df <- data.frame(a=x1, b=x2, c=x3, d=x4)

ggplot(df, aes(a,b)) + geom_point()  # easy geom_point plot

ggplot(df, aes(a,b,color=c)) + geom_point(alpha=0.5) +
  labs(title = "first plot", x = "x axis \n and a new line") # adding color to the plot (color = column), adding labels and changing translucency

ggplot(df, aes(a)) + geom_histogram(color = "white") # creating a histogram
ggplot(df, aes(a)) + geom_density(color = "red")


p1 <- ggplot(df) + 
  geom_histogram(aes (a, ..density..),fill = "blue", colour = "darkgrey", alpha = 0.5) +
  geom_density(aes(a, ..density..), colour = "red") +
  geom_rug(aes(a), color = "grey")

ggplot(df, aes(c, color = c)) + geom_point(stat = "count", size = 4)

ggplot(df) + geom_bar(aes(c)) + coord_flip()

ggplot(df, aes(d, fill = c)) + 
         geom_bar(position = "dodge")

# # 3d plotting
# 
mtplot = ggplot(mtcars) +
  geom_point(aes(x = mpg, y = disp, color = cyl)) +
  scale_color_continuous(limits = c(0, 8))

par(mfrow = c(1, 2))
plot_gg(mtplot, width = 3.5, raytrace = FALSE, preview = TRUE)

plot_gg(mtplot, width = 3.5, multicore = TRUE, windowsize = c(800, 800),
        zoom = 0.85, phi = 35, theta = 30, sunangle = 225, soliddepth = 100)


# normal plotting continues

ggplot(df, aes(d,a )) + geom_boxplot() + geom_jitter(alpha = .5, width = .3, color = "blue")

ggplot(df, aes(a,b )) + 
  geom_boxplot(aes(group = cut_width(a,0.5)), outlier.alpha = 0.1) +
  geom_jitter(width = 0.01, size = .7 , alpha = .5, color = "blue" )

ggplot(df, aes(c)) +
  geom_bar() + facet_grid(d ~ .)

ggplot(df, aes(a,b)) +
  geom_point(size = 1) + geom_density2d()


## ggplot Steigerwald 

names(df)
head(df)

# adding different plots together

a <- ggplot(df, aes(x=L8.ndvi, y=L7.ndvi, colour = SRTM))
a <- a + geom_point()
a <- a + geom_smooth()
a <- a + facet_wrap(~LCname)
a

# plot SAVI per Landcover
b <- ggplot() + geom_point(data = df, aes(LCname, L8.savi, colour = SRTM))
b

# boxplot with jitter 

c <-  ggplot(df,aes(x=LCname, y=L8.savi))+
  geom_boxplot(alpha =.5)
c <- c + geom_point(aes(colour=SRTM), alpha =.7,size=1.5,position=position_jitter(width=.25, height=0))

# violin plot + jitter
c + geom_violin() +geom_jitter()

# density plot
ggplot(df,aes(x=TimeScan))



# ridgeplots
ggplot(df, aes(x=MOD.evi, y=LCname)) + geom_density_ridges2()



## Animating in R
# playing around with plot animations

p <- ggplot(data=df, aes(y=L8.ndvi, x=L8.evi, color=LCname, ))+
  geom_point(alpha=.8) + geom_smooth(method = lm)

d <- ggplot(data=df, aes(L8.savi, color=LCname, fill = LCname)) + geom_density(alpha = 0.5) 
  
p + transition_states(LCname, transition_length = 20, state_length = 20, wrap = TRUE) +
  ease_aes('sine-in-out')+
  # labs(title = "semester:{closest_state}")+
  enter_fade() +
  exit_shrink() + 
  theme_minimal()


# Add new column to df and cut SRTM

df$SRTM_Rec <- cut(df$SRTM,
                   breaks = c(-Inf, 300, 400, Inf),
                   labels = c("<300m", "300-400m", ">400m"))

# pointplot wrapped around SRTM_Rec

p <- ggplot(data=df, aes(y=TimeScan.NDVIsd, x=TimeScan.NDVIavg, color=LCname, ))+
  geom_point(alpha=.8) +
  facet_wrap(~SRTM_Rec)

p + transition_states(LCname, transition_length = 20, state_length = 20, wrap = TRUE) +
  ease_aes('sine-in-out')+
  # labs(title = "semester:{closest_state}")+
  enter_fade() +
  exit_shrink()  
