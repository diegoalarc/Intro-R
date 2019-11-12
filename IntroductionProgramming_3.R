## Working with spatial data (Steigerwald), 05.11.2019

install.packages("raster")
library(datapasta)
library(raster)

# creating a list, and querying different data sets
# a <-  runif(199)
# b <- c("aa","bb","cc","dd")
# c <- list(a,b)
# 
# df$newcol <-df$measure1 * df$measure2
# head(df)
# 
# df[grep("a", df$ID, ignore.case = T),]

# random list of yes and no
x1 <-  rbinom(10, size = 1, prob = 0.5)
x2 <-  factor(x1, labels=c("yes","no"))
summary(x2)
levels(x2)
as.character(x2) # conversion from factors to characters

# recode from yes/no to sure/maybe

library(car)
recode(x2, "'yes' = 'sure'; 'no' = 'maybe'")
# or use an ifelse
ifelse(x2=="no", "maybe", "sure")

# working with actual data (Steigerwald Datasets)

setwd("F:/Eagle/Introduction_Programming/Scripts")
df <- read.csv("output.csv")

#only selecting SRTM and LUCAS_LC
LUCAS_SRTM <- df[,c("SRTM","LUCAS_LC")]

# all columns, but just 10 rows
First10 <- df[1:10,]

# second last column
secondlast <- df[,length(df)-1]


df[, "SRTM" & "L8.ndvi" > 0.5] # look up querying data

spdf.obj <- df
names(spdf.obj)

library(sp)

coordinates(spdf.obj) <-  ~x+y

library(rgdal)
proj4string(spdf.obj) <- CRS("+init=epsg:32632")

df3 <- df[df$LUCAS_LC > 0.3 & df$L8.ndvi > 0.4,]
writeOGR(df3, ".", layer = "Plotly", driver = "ESRI Shapefile")
dummy <-  as.data.frame(spdf.obj)

# data frame and raster data

library(raster)
r1 <- raster(nrows=100, ncols=100)
r1

df <- data.frame(plot="location_name_1", measure1=runif(100) * 1000, measure2=round(runif(100)*100),
                   value =rnorm(100,2,1), ID=rep(LETTERS,100)[1:100])

# populate empty rasters with "Rastername[]"
r1[] <- df$measure1[1:1000]
plot(r1)

# create second raster r2 
r2 <- raster(nrows=100,ncols=100)
r2[] <- df$measure2[1:1000]

# create raster stack
r12 <-  stack(r1,r2)
plot(r12[[2]])

r12$new <- r12[[1]] * r12[[2]]^2  # creating a new Raster Layer
df12 <- r12[]   # you can easily convert raster values to a new data frame
head(df12)

str(r12)  # looking at the object structure

lsat <- data(lsat)
