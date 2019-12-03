# Session 03.12.2019

# created Raster from IntroductionProg3 

r12$new2 <- (r12[[2]] / r12[[3]]) * r12[[1]]

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

library(RStoolbox)
library(rgdal)

td <- readOGR("F:/Eagle/Introduction_Programming/Training_Data.shp")
plot(nov[[1]])
plot(td, add=T)

sc <-  superClass(nov,trainData = td,
                  responseCol = "Class",
                  filename = "Classification.tif")
plot(sc$map)

