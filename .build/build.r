install.packages("installr", contriburl="https://cloud.r-project.org/bin/windows/contrib/3.5/")
install.packages("devtools", contriburl="https://cloud.r-project.org/bin/windows/contrib/3.5/")
install.packages("roxygen2", contriburl="https://cloud.r-project.org/bin/windows/contrib/3.5/")

library("installr")
install.Rtools()

library("devtools")
library("roxygen2")

setwd("./pactr")
devtools::document(roclets=c('rd', 'collate', 'namespace'))
