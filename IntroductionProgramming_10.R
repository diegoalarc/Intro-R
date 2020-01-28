# 21.01.2020 -- Statistics in R -- IntroductionProgramming10_Stat

install.packages("TeachingDemos")
library(TeachingDemos)


if(interactive()){
                  put.points.demo()
  
                  x <- rnorm(25,5,1)
                  y <- x + rnorm(25)
                  put.points.demo(x,y)
}


install.packages("gsheet")
library(gsheet)


source("http://janhove.github.io/RCode/plot_r.R")

plot_r(r = 0.5, n = 50)
plot_r(r = 0.8, n = 50)
plot_r(r = 0.1, n = 50)


plot_r(r = 0.1, n = 50, showdata = 11)
plot_r(r = 0.1, n = 50, showdata = "all")

# Run correlation on a raster stack

x <- brick(...)

cm <- cor(getValues(x),use="complete.obs")

library(ellipse)
plotcorr(cm,col=ifelse(abs(cm)>0.7,"red","grey"))


library(RStoolbox)
library(ggcorrplot)
install.packages("ggcorrplot")

data(mtcars)
p.mat <- cor_pmat(mtcars)
p.mat

ggcorrplot(p.mat,method="square")

# Run spatial correlation on two Raster.
.
.
.
# More next week!



data(stork)

plot(stork)
summary(stork)

cor(stork$No.storks, stork$No.babies)
cor.test(stork$No.storks, stork$No.babies)



library(RCurl)

x <-  read.csv(textConnection(getURL("https://docs.google.com/spreadsheets/d/e/2PACX???1vTbXxJqjfY???voU???9UWgWsLW09z4dzWsv9c549qxvVYxYkwbZ9RhGE4wnEY89j4jzR_dZNeiWECW9LyW/pub?gid=0&single=true&output=csv")))


library(reshape2)

x2 <- melt(data=x)


######

x.cs <- data.frame(variable=names(x),cs=t(cumsum(x)[nrow(x),]))

names(x.cs) <- c("variable","cumsum")

x2 <- melt(data=x)

x3 <- merge(x.cs,x2,by.x="variable",all=T)

# plot the sum as color
ggplot(x3,aes(x=variable,y=value,color=cumsum)) + geom_point()

#plot points plus boxplot and add a jitter (again: important to inform if jitter is used)
ggplot(x3, aes(x=variable, y=value, color=cumsum)) + geom_boxplot(alpha=.5) +
  geom_point(alpha=.7,size=1.5,position=position_jitter(width = .5, height = .75)) + 
  scale_colour_gradientn(colours = rainbow(7))


library(gender)
x.g <- gender(tmp) # doesnt work

colnames(x.g)[1] <- "variable"




library(RStoolbox)
data <- brick("C:/Users/Marius/Desktop/Data/Bodensee/Brick_20m_def.tif")
data <- subset(data,2:10)
uc <- unsuperClass(data,nClass = 5)
