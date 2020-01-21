# Session 03.12.2019

# created Raster from IntroductionProg3 

r12$new2 <- (r12[[2]] / r12[[3]]) * r12[[1]]

#test 

library(RStoolbox)

ggRGB(r12, r = 2, b= 3, g= 1)
str(r12)

lsat[[1]]
lsat$B1_dn
plot(lsat[[1]])
data(lsat)
x <- lsat[1:10,]

# Using data from Bachelor Thesis to compute vegetation indices

setwd("F:/Bachelor/BA/DATEN/Sentinel2")

dez <- brick("Dez_10m.grd")
nov <- brick("Nov_10m.grd")
jan <- brick("Jan_10m.grd")

list <- c(dez,nov,jan)

for (i in 1:length(list)){
  list[[i]] <- list[[i]]/10000
}

index_dez <- spectralIndices(list[[1]], red = "B04_10m", nir = "B08_10m")
index_nov <- spectralIndices(list[[2]], red = "B04_10m", nir = "B08_10m")
index_jan <- spectralIndices(list[[3]], red = "B04_10m", nir = "B08_10m")

list <- c(index_nov,index_dez,index_jan)

for (i in 1:3){
  stack <- list[[i]]
  plot(stack[["NDVI"]])
}


# Raster classification

library(raster)
library(cluster)

df <-  jan[]/10000

kmeans_out <- kmeans(df, 12 ,iter.max = 200, nstart = 10) # clustering

kmeans_raster <- raster(jan)
kmeans_raster[] <-  kmeans_out$cluster
plot(kmeans_raster)

# kmeans using RStoolbox

data(lsat)

uc <- unsuperClass(lsat, nClasses = 7)

ggR(uc$map, forceCat = T, geom_raster = T)

#Supervised classification using training data polygons created in QGIS 
#and function superClass()

setwd("F:/Bachelor/BA/DATEN/VI/Sentinel2")

dez <- brick("Dez_10m.grd")
nov <- brick("Nov_10m.grd")
jan <- brick("Jan_10m.grd")

vi <- brick("VI_Nov_10m.grd")
hillshade <- raster("hillshade.tif")


library(RStoolbox)
library(rgdal)

td <- readOGR("F:/Eagle/Introduction_Programming/Training_Data.shp")
  plot(nov[[1]])
plot(td, add=T)

sc <-  superClass(nov,trainData = td,
                  responseCol = "Class", trainPartition = 0.5,
                  model = "rf",
                  filename = "Classification_svm.tif")
a <- ggR(sc$map, forceCat = T, geom_raster = T) +
  scale_fill_manual(values = c("yellow","red","brown","green","black"),
                    labels = c("Agriculture", "Built up", "Forest_noLeaf", "Forest_Leaf", "Shadow"))

sc$validation$performance


###########################################################

setwd("F:/Eagle/Introduction_Programming/")

# Extensive random forest code

library(maptools)
library(randomForest)
library(raster)
library(rgdal)

vec <- readOGR("F:/Eagle/Introduction_Programming/Training_Data.shp")
satImage <- nov

# Number of sample points
numsamps <- 100

# id col name
attName <- "id"

# output imagery name
outImage <- "randF_result.tif"


# loop over each class, selecting all polygons and assign random points

tmp <- compareCRS(vec, satImage)
if(tmp == TRUE){
uniqueAtt <- unique(vec[[attName]])
for (x in 1:length(uniqueAtt)) {
  class_data <- vec[vec[[attName]] == uniqueAtt[x],]
  classpts <- spsample(class_data,type="random",n=numsamps)
  if (x == 1){
    xy <- classpts
  } else {
    xy <- rbind(xy, classpts)
  }
}}else {print("The projections dont match!")}

# plot the random generated points on one of the rasters - visual check
pdf("training_pts.pdf")
  image(satImage,1)
  points(xy)
dev.off()

# extracting pixel val for training data

temp <- over(x=xy, y=vec)
response <- factor(temp[[attName]])
trainvals <- cbind(response, extract(satImage, xy)) # combine point with raster val

# Fit model 

print("Starting to calculate rf object")
randfor <- randomForest(as.factor(response) ~. ,
                        data = trainvals,
                        na.action = na.omit,
                        confusion = T)

# apply to raster

print("Starting prediction")
predict(satImage, randfor, filename=outImage, progress='text', format='GTiff',datatype='INT1U',
        type='response', overwrite = T)


# it works :) 




# extract temporal boundaries per year

tb = list()
  if(sYear == eYear) {tb[[1]] = c(sDoy,eDoy)}
    if(sYear != eYear){
      for(y in 1:nYears){
        if((sYear+(y-1) %% 4) > 1) {nDays = 366} else {nDays = 365} # number of Days in the year
          if(y == 1) {tb[[1]] = c(sDoy,nDays)}
            if(y > 1) {tb[[length(tb)+1]] = c(0,nDays)}
              }
            if(y == nYears) {tb[[length(tb)+1]] = c(0,as.numeric(eDoy))}
    }








