## Vector Data, Frames, Indexing
# 29.10.2019

# fun functions 
install.packages("fun")
library(fun)

x11()   ## if else 
mine_sweeper(width = 100, height = 100, cheat = TRUE)

install.packages("sudoku")

library(sudoku)
playSudoku()

# playing games all day

# get praised 

devtools::install_github("gaborcsardi/praise")
library(praise)
praise()

# how many days until christmas? 

diffChristmas <- difftime("2019-12-24", Sys.Date(), units = "secs")

# read table in R 

setwd("F:/Eagle/Introduction.Programming.Geostatistics/Scripts")

table <- read.table("test.csv", header = T, sep = ",")
#
table <-  read.csv("test.csv")      # use real useful files next time 

head(table)
View(table)

# datapasta, directly copy from excel sheet and paste as data.frame 

install.packages("datapasta")
library(datapasta)

test.df <- data.frame(stringsAsFactors=FALSE,
        FirstName = c("A", "Z", "A", "P"),
         Lastname = c("B", "D", "E", "T"),
              Sex = c("M", "M", "F", "F"),
   FavouriteColor = c("blue", "red", "yellow", "green")
)


# Steigerwald data

install.packages("RCurl")
library(RCurl)


df <- read.csv("https://raw.githubusercontent.com/wegmann/R_data/master/Steigerwald_sample_points_all_data_subset_withNames.csv")
head(df)
tail(df)
names(df)
class(df)
dim(df)
plot(df$TimeScan.mNDWImax)


# Indexing 

x <-seq(1,1000,10)

x[24]
x[1:25]

len <- length(x)
x[len]  # extract last value

x[-len] # extract everything except last value

idx <- c(1,4,6)
x[idx]
x[-idx]

xdata <- (x < 10) | (x >= 30)  # output is boolean
x[x<10|x>30]                   # query data 

x2 <-  numeric(length(x))   # replacing values in a vector
x2[x<=30] <-  1
x2[(x>30)&(x<500)] <-  2
x2[x>=500] <-  3
x2

install.packages("car")            # same thing can be done with a package
library(car)

x2 <-  recode(x,"0:50 = 1; 50:500 = 2; else = 3")

summary(x)
sum(x)
cumsum(x)

rev(x)
sort(x,decreasing=T)


# Matrix Data

m1 <- matrix(x, nrow = 10, byrow)

m1[2,]
m1[,2]
m1[2,2]

# Creating Matrix from Vector -> convert into Dataframe -> name the columns 

numbers_1 <- rnorm(1000, mean = 0, sd = 1)
mat_1 <- matrix(numbers_1, nrow = 250, ncol = 4)
mat_1

df_1 <- data.frame(mat_1)
names(df_1) <- c("var1","var2","var3","var4")

scatterplot(df_1$var1,df_1$var2)
boxplot(df_1)

# indexing data.frame (query data)

test <-  data.frame(A=c(1,2,3), B=c("aB1","aB2","aB3"))
test

# all do the same

test[,1]
test[,"A"]
test$A

test$A[1:2]
test[2:3,1:2]

# a little more complex

df_1 <- data.frame(plot="location_name_1", measure1=runif(100) * 1000, measure2=round(runif(100)*100),
                   value =rnorm(100,2,1), ID=rep(LETTERS,100)[1:100])
df_2 <- data.frame(plot="location_name_2", measure1=runif(50) * 100, measure2=round(runif(50)*10),
                   value =rnorm(50), ID=rep(LETTERS,50)[1:50])

df <- rbind(df_1,df_2)
head(df)

View(df[100:105,c("plot","measure1","measure2")])


# creating list

a <- c(1,2,3,4,5,6)
b <- c("a","b","c","d","e","f")
c <- list(a,b)

# randomizer w. all names