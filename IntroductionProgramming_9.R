# Intro-R session 14.01.2020
setwd("C:/Users/Marius/Desktop/Test/data_book/")


# postclass 

w88 <- brick("raster_data/final/p224r63_1988.gri")
w11 <- brick("raster_data/final/p224r63_2011.gri")

td88 <- rgdal::readOGR("vector_data/")
td11 <- rgdal::readOGR("vector_data/training_2011.shp")





#multidate

setwd("C:/Users/Marius/Desktop/Test/data_book/")

l88 <- brick("raster_data/final/p224r63_1988.gri")
l11 <- brick("raster_data/final/p224r63_2011.gri")

stack <- stack(l88,l11)

pol <- rgdal::readOGR("vector_data/training_2011.shp")

sc <- superClass(img = stack,trainData=pol,responseCol=pol$class_name)


#cva

x88 <- brick("raster_data/final/p224r63_1988.gri")
x11 <- brick("raster_data/final/p224r63_2011.gri")

stack <- stack(x88,x11)

cva1 <- RStoolbox::rasterCVA(x88[[3:4]],x11[[3:4]])

tas88 <- RStoolbox::tasseledCap(x88[[c(1:5,7)]],sat = "Landsat5TM")
tas11 <- RStoolbox::tasseledCap(x88[[c(1:5,7)]],sat = "Landsat5TM")

cva2 <- RStoolbox::rasterCVA(tas88[[2:3]],tas11[[2:3]])

# define own colour palette

jet.colours_angle <- colorRampPalette(c("#00007F","blue","grey",
                                        "lightgrey","red","yellow","#7FFF7F",
                                        "#366C36"))

 


# EDA

install.packages("visdat")
library(visdat)


titanic <- read.csv("C:/Users/Marius/Desktop/titanic.csv")
medpar <- read.csv("C:/Users/Marius/Desktop/medpar.csv")
biomass <- read.csv("C:/Users/Marius/Desktop/biomass.csv")


vis_dat(biomass)
biomass_sub <- subset.data.frame(biomass,select=c(dbh,wood,bark,branch,root,rootsk))

vis_cor(biomass_sub)
