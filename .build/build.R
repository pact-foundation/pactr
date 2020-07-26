library("devtools")
library("roxygen2")

setwd("./pactr")

devtools::document(roclets=c('rd', 'collate', 'namespace'))
devtools::build(".")

