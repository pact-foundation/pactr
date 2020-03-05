install.packages("devtools")
install.packages("roxygen2")
install.packages("packrat")


library("devtools")
library("roxygen2")

setwd("./pactr")
packrat::restore()
devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".") 
