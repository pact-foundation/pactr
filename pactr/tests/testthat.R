library(testthat)
library(pactr)

# stand up consumer up
config <- pactr::MockServerConfig$new()
config$setPort("7200")
config$setHost("127.0.0.1")
config$setConsumer("someConsumer")
config$setProvider("someProvider")
config$setPactDir(paste0(getwd(), "/../output"))
config$setPactFileWriteMode("overwrite")

mockServer <- MockServer$new(config, install_dir=paste0(getwd(), "/../pact-bin"),
                             list("stdout" = "../example/logs/consumer_mock_service_stdout.log", 
                                  "stderr" = "../example/logs/consumer_mock_service_stdout.log"))
consumer_process <- mockServer$start()

# stand up provider

plumber_server_runner <-
  pactr::ProcessRunner$new(
    "/usr/bin/Rscript",
    c("--vanilla", "../example/run_server.R"),
    list("stdout" = "../example/logs/provider_service_stdout.log", 
         "stderr" = "../example/logs/provider_service_stderr.log")
  )
plumber_server_process <- plumber_server_runner$runNonBlocking()


Sys.sleep(5)

test_dir("./tests/testthat/")
#test_check("pactr")

# tear down consumer
consumer_process$kill_tree()
plumber_server_process$kill_tree()
