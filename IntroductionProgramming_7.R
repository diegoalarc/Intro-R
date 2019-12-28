# session 10.12.2019 , accuracy of data classification

# hold out proportion of training data for validation
sc <- superClass(nov, trainData = td, responseCol = "Class", trainPartition = 0.5, mode = "classification")

sc$validation$performance


# make a plot, show run of validation data


# create a matrix
m <- matrix(data=cbind(rnorm(30,0), rnorm(30,2), rnorm(30,5)), nrow = 30, ncol=3)

mean(m[,1])
mean(m[,2])

#or

m.mean <- vector()
m.mean <- for(i in 1:3){
  m.mean[i] <- mean(m[,i])
  }

#or

apply(m,1,mean) #rows

apply(m,2,mean) #columns

# stats to execute: mean, range, sum, fivenum etc. 


apply(m,1,function(x) length(x[x<0.2]))

apply(m,2,function(x) mean(x[x>0]))


sapply(1:3, function(x) x^2) # returns vector
lapply(1:3, function(x) x^2) # returns list

# reshaping your data
install.packages("reshape2")

View(df)

df_n <- melt(df, id=c("NAID","NABlock","NAlon","NAlat"))

reshape()