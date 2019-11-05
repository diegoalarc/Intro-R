# First R session // 22. 10. 2019 // Prog. & Geostatistics


#  Basic Math 

5+6

5 * 5^4 - 88 * 15

1/0


result1 <- 5+6
result1


seq1 <-  seq(1,100, by = 1)

a <- c(1,3,5,7,9)

x <- c(1:7)

vec1 <- c(x,a)
vec2 <- c(a,x)
names <- c("a","b","c","d", "e", "f", "g")

vecChar <- as.character(c(a,x))
df <- as.data.frame(x, row.names = names )

summary(df)

#  c() coerces into vector, 
prec_avg <-  c(56,46,50,53,69,83,83,80,62,55,60,63)

plot(prec_avg,
     pch = 19,
     cex = 2,
     col = "red") 

lines(lowess(prec_avg, f = .2))

# ggplot test df plot

list1 <- sample(100)
list2 <- sample(100)


df <- data.frame(list1,list2)

library(ggplot2)

p1 <- ggplot(df, aes( x = list1, y = list2)) + geom_point(color = "red") + 
  geom_smooth(method = "lm", se = TRUE) 

# spatial data handling

install.packages("raster")
library(raster)

germany <- getData("GADM", country = "DEU", level=2) # get country borders, other codes can be found in the manual

plot(germany)

prec <- getData("worldclim", var = "prec", res = .5, lon =10, lat = 51) # get precipitation data, lat/lon only

plot(prec)

prec_ger1 <- mask(prec, germany) # crop to extent of germany shapefile
spplot(prec_ger1)

prec_ger2 <- crop(prec_ger1, germany) # mask prec to shape of germany shapefile 
spplot(prec_ger2)

# statistics from spatial data

prec_avg <- cellStats(prec_ger2, stat="mean")

plot(prec_avg, line = )
