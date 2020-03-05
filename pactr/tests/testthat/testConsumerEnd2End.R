library(pactr)


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

test_that("Test that pact is created", {
  #Sys.sleep(10)
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
  #body <- list("message" = matcher$somethingLike("Hello, Bob"))
  body <- list("message" = matcher$term("Hello, Bob", "(Hello, )[A-Za-z]"))
  response$setBody(body)

  # duplicate in test_that.R.  find a global config for tests.
  config <- pactr::MockServerConfig$new()
  config$setPort("7200")
  config$setHost("127.0.0.1")
  config$setConsumer("someConsumer")
  config$setProvider("someProvider")
  config$setPactFileWriteMode("overwrite")
  config$setPactDir(paste0(getwd(), "/../output"))
  config$setPactSpecificationVersion("2.0.0")

  builder<-pactr::InteractionBuilder$new(config)
  builder$uponReceiving("Hello Bob")
  builder$with(request)
  builder$willRespondWith(response)

  # use your libary of choice to send a request
  status <- sendRequest(config, request)
  expect_equal(as.integer(status), 200)

  result <- builder$verify()
  expect_equal(result, TRUE)
  
  # write the pact for the testProviderEnd2End
  builder$finalize()
})


