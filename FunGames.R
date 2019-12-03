# fun functions 
install.packages("fun")
library(fun)

x11()   ## if else 
mine_sweeper(width = 100, height = 100, cheat = TRUE)

install.packages("sudoku")

library(sudoku)
playSudoku()

# playing games all day


devtools::install_github("gaborcsardi/praise")
library(praise)
praise()


# fun stuff  12.11.

install.packages("brickr") # not available for r 3.6.1
install.packages("rwhatsapp") # analyse your conversations
install.packages("ggthemes")

# fun stuff 26.11. --> skraahhhh boi 

devtools::install_github("brooke-watson/BRRR")
library(BRRR)

f <- function(sound, sleep = 0.75){
  Sys.sleep(sleep)
  BRRR::skrrrahh(sound)
}

for(i in 1:5){
  f(0)
}

# fun stuff 03.12.

????""

devtools::install_github("gsimchoni/kandinsky")
library(kandinsky)
kandinsky(df)
