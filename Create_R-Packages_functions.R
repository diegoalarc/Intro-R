## Building your own R-packages, and the working with functions 19.11.2019

install.packages("roxygen2")
install.packages("devtools", dependencies = T)
library(devtools)
library(roxygen2)

# check for a development environment
has_devel()
