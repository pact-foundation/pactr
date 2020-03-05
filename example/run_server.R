library(plumber)

#print("Yup")
pr <- plumber::plumb(paste0("/home/cmack/pactr/example", "/plumber.R"))
pr$run(port=8000)