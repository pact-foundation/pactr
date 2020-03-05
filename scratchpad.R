#library(httr)
library(jsonlite)
#library(rjson)
#library(RCurl)
#library(readr)
#library(curl)


#r <- read_file(file="D:/Temp/gorilla-zoo-pact.json")




#headers = c(
#  "X-Pact-Mock-Service" = "true",
#  "Content-Type" = "application/json"
#)

#req <- POST(url="http://localhost:60739/interactions", body=r, add_headers(.headers = c(
  #"X-Pact-Mock-Service" = "true",
  #"Content-Type" = "application/json"
#)))

#stop_for_status(req)
#content(req, "parsed", "application/json")




#raw <- '{"description": "General Meetup Categories 6","providerState": "A GET request to return JSON using Meetups category api under version 2 6","request": {"method": "GET","headers": {"Content-Type": "application/json"},"path": "/6/categories"},"response": {"status": 200,"headers": {"Content-Type": "application/json"},"matchingRules": {},"body": {"results": {"name": "Games","sort_name": "Games","id": 11,"shortname": "Games"}}}}'
#raw

#h = basicTextGatherer()
#result <- curlPerform(url = "http://localhost:60739/interactions",
#                      httpheader=headers,
#                      postfields=jr,
#                      writefunction = h$update,
#                      verbose = TRUE
#)
#result
#h$value()

config <- MockServerConfig$new()
config$setPort(7200)$setHost("localhost")

service <- MockServerHttpService$new(config)
service$healthCheck()

#j <- read_json(path="D:/Temp/gorilla-zoo-pact.json")
#interactionStr <- paste0('', toJSON(j, auto_unbox = TRUE))
#service$registerInteraction(interactionStr)
#service$deleteAllInteractions()

#c

#service$healthCheck();
#curl <- getCurlHandle()
#curlSetOpt(.opts = list(httpheader = c(
    #"X-Pact-Mock-Service" = "true",
    #"Content-Type" = "application/json"
  #),
  #verbose = TRUE),
  #curl = curl
#)

#uri <- paste0(config$getUri()) ;
#getURLContent(url=uri, curl=curl)


#res <- httpDELETE(url = paste0(config$getUri(),"/interactions"), curl=curl)
#res[1]

req <- ConsumerRequest$new(method="get", path="/6/categories")
headers <- list(
  #"X-Pact-Mock-Service" = "true",
  "Content-Type" = "application/json"
)

req$setHeaders(headers)

res <- ProviderResponse$new()
res$setStatus(200)
res$setHeaders(headers)

body <- list(
  description = "General Meetup Categories Response"
)
res$setBody(body)

int <- Interaction$new();
int$setProviderState("My State")
int$setDescription("My Description")
int$setRequest(req)
int$setResponse(res)

interactionStr <- jsonlite::toJSON(int$jsonReady(), auto_unbox = TRUE)

service$registerInteraction(interactionStr)
url <- paste0(config$getUri(),req$getPath())

service$performPactConsumerHttpRequest(config$getUri(), req)
service$verifyInteractions()

pactJSON <- service$getPactJson()
pactJSON <- toJSON(fromJSON(pactJSON), auto_unbox = TRUE, pretty = TRUE)
pactJSON

library("R6")
source("./R/installer/InstallerLinux.R")
source("./R/installer/PactScripts.R")
installer <- InstallerLinux$new()
installer$install("/tmp")

# process management
cmd <- 'ls -alt /home'
out <- system(cmd)
# looks to be the error code: 0

cmd <- 'ls -alt /hm'
out <- system(cmd)
#ls: cannot access /hm: No such file or directory
out
#[1] 2

# subprocess
# https://cran.r-project.org/web/packages/subprocess/vignettes/intro.html
library(subprocess)
shell_binary <- function () {
  ifelse (tolower(.Platform$OS.type) == "windows",
          "C:/Windows/System32/cmd.exe", "/bin/sh")
}

handle <- spawn_process(shell_binary())
print(handle)

process_write(handle, "php /home/cmack/Code/turner.php\n")

process_write(handle, "php /home/cmack/pact-php/log/testproc.php\n")

#> [1] 3
Sys.sleep(1)
process_read(handle, PIPE_STDOUT)
#> [1] "intro.Rmd"
process_read(handle, PIPE_STDERR)
#> character(0)
process_state(handle)

# windows
#process_kill(handle)
process_terminate(handle)
#> [1] TRUE
process_wait(handle, 1000)
#> [1] 1
process_state(handle)
#> [1] "exited"

#go use processx instead!


testGetHelloString <- function(scripts, config, builder) {
  request <-
    pactr::ConsumerRequest$new(path = "/hello/Bob", method = "GET")
  headers <- list("X-Pact-Mock-Service" = "true",
                  "Content-Type" = "application/json")
  request$setHeaders(headers)
  
  response <- pactr::ProviderResponse$new()
  response$setStatus(200)
  headers <- list("Content-Type" = "application/json")
  response$setHeaders(headers)
  
  matcher <- pactr::Matcher$new()
  body <- list("message" = matcher$somethingLike("Hello, Bob"))
  response$setBody(body)
  
  builder$uponReceiving("Hello Bob")
  builder$with(request)
  builder$willRespondWith(response)
  
  status <- sendRequest(config, request)
  
  builder$verify()
  
  return(status)
}

sendRequest <- function(config, consumer_request) {
  url <- paste0(config$getUri(), consumer_request$getPath())
  print(url)
  
  h = basicHeaderGatherer()
  res <- getURI(
    url,
    .opts = list(httpheader = consumer_request$getHeaders(),
                 verbose = TRUE),
    headerfunction = h$update
  )
  
  statusCode <- h$value()["status"]
  return(statusCode)
}

run_service <- function(config) {
  installer <- pactr::InstallerLinux$new()
  scripts <- installer$install(paste0(getwd(), "/../pact-bin"))
  args <- c(
    '--consumer=someConsumer',
    '--provider=someProvider',
    paste0('--pact-dir=', getwd(), "/../output"),
    '--pact-file-write-mode=overwrite',
    paste0('--host=', config$getHost()),
    paste0('--port=', config$getPort()),
    '--pact-specification-version=2.0.0'
  )
  
  process_runner <-
    pactr::ProcessRunner$new(scripts$mockService, args)
  process <- process_runner$runNonBlocking()
  return(process_runner)
}

config <- pactr::MockServerConfig$new()
config$setPort("7200")
config$setHost("127.0.0.1")
mock_server_process_runner <- run_service(config)
Sys.sleep(5)
builder<-pactr::InteractionBuilder$new(config)
testGetHelloString(scripts, config, builder)
builder$finalize()
Sys.sleep(5)

config <- pactr::MockServerConfig$new()
config$setPort("7200")
config$setHost("localhost")
config$setConsumer("someConsumer")
config$setProvider("someProvider")

mockServer <- MockServer$new(config, install_dir="../pact")
p <- mockServer$start()


#mock_server_process_runner$stop()
#mock_server_process_runner$getExitCode()

#### verifier
# stand up a plumber service to hit with this example



plumber_server_runner <-
  pactr::ProcessRunner$new(
    "/usr/bin/Rscript",
    c("--vanilla", "/home/cmack/pactr/example/run_server.R"),
    list("stdout" = "/home/cmack/pactr/example/out.txt", "stderr" = "/home/cmack/pactr/example/err.txt")
  )
plumber_server_process <- plumber_server_runner$runNonBlocking()


config <- pactr::PactVerifierConfig$new();
config$setProviderName("someProvider");
config$setProviderBaseUrl("http://localhost:8000");
config$setProviderVersion("1.0.0");
verifier <- pactr::PactVerifier$new(config);
process_x_args = list("stdout" = "|", "stderr" = "/home/cmack/pactr/example/verr.txt")
verifier <- verifier$verifyFiles(c("/home/cmack/pactr/output/someconsumer-someprovider.json"), process_x_args)

#why does this not work?
plumber_server_runner$stop()
plumber_server_process$kill_tree()

matcher = pactr::Matcher$new()
body <- list()
term <- matcher$somethingLike("Hello, Bob")
body[['message']] <- as.list(term[1,])
jsonlite::toJSON(body, auto_unbox = TRUE)

body <- list()
body[["message"]] = "Hello, Bob"
jsonlite::toJSON(body, auto_unbox = TRUE)

matcher = pactr::Matcher$new()
term <- matcher$term("Hello, Bob", "(Hello, )[A-Za-z]")
jsonlite::toJSON(term, auto_unbox = TRUE, pretty = TRUE)
