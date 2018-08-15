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

#config <- MockServerConfig$new()
#config$setPort(60742)$setHost("localhost")

#service <- MockServerHttpService$new(config)

#j <- read_json(path="D:/Temp/gorilla-zoo-pact.json")
#interactionStr <- paste0('', toJSON(j, auto_unbox = TRUE))
#service$registerInteraction(interactionStr)
#service$deleteAllInteractions()
#c <- service$healthCheck()
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

req <- ConsumerRequest$new(method="POST")
headers <- list(
  "X-Pact-Mock-Service" = "true",
  "Content-Type" = "application/json"
)

req$setHeaders(headers)

req$setBody("Hello Mary")

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

jsonlite::toJSON(int$jsonReady(), pretty = TRUE, auto_unbox = TRUE)

