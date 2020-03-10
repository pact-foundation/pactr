[![Build Status](https://travis-ci.org/pact-foundation/pactr.svg?branch=master)](https://travis-ci.org/pact-foundation/pactr)

# Pact R

R version of [Pact](https://pact.io). Enables consumer driven contract testing. Please read the [Pact.io](https://pact.io) for specific information about PACT.

#To Do
- Create Mac version of the installer 
- Find a way to gracefully shut down the thread even if the R session gets out of whack (freeze RStudio)
- Find the right way to bootstrap consumer servers in unit tests.  Perhaps in testthat.R
- Add hooks into the Pact Broker
- Build getParameters() for consumer rather than outside in scratchpad.R example
- Do input valiation on PactVerifierConfig
- allow PactVerifier->verifyAction via config set the pact ruby install directory
- Figure out if you want to put process_x_args into PactVerifier Configs
- Make sure to denote in the read me that passing "|" will result in a blocking process.  Test what happens if it is done into the NonBlocking argument.  Maybe even through an error or warning.
- PactVerifier do something with processTimer and processIdleTimer
- something is goofy when attempting to kill a process in linux using stop().
- build out the rest of the process x wrapper commands into ProcessRunner.R process_x_args and buildProcess()
- Create devtools::install_github()
- Get Travis CI with a compiling build
- Add Packrat for dependency management
- Run tests via Travis CI
- Much much more ...

## Versions

This is very much a work in progress (as you likely see from the to do list)

## Specifications

The intent is to support [Pact-Specification 2.X](https://github.com/pact-foundation/pact-specification/tree/version-2).
		
## Installation

When it is complete, you should be able to install it with:

```R
# install from CRAN
> install.packages("pactr")

# install from GITHUB
> devtools::install_github()
```


## Basic Consumer Usage

All of the following code will be used exclusively for the Consumer.

### Start and Stop the Mock Server

This library contains a wrapper for the [Ruby Standalone Mock Service](https://github.com/pact-foundation/pact-mock_service).

The easiest way to configure this is to wrap this in your testthat.R file directly. 

```R
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
```

### Create Consumer Unit Test

Create a standard testthat test case function.  The below as a breakdown but also check the examples folder or the tests in this library.

### Create Mock Request

This will define what the expected request coming from your http service will look like.

```R
  request <-  pactr::ConsumerRequest$new(path = "/hello/Bob", method = "GET")
  headers <- list("X-Pact-Mock-Service" = "true",
                  "Content-Type" = "application/json")
  request$setHeaders(headers)
```

You can also create a body just like you will see in the provider example.

### Create Mock Response

This will define what the response from the provider should look like.

```R
  response <- pactr::ProviderResponse$new()
  response$setStatus(200)
  headers <- list("Content-Type" = "application/json")
  response$setHeaders(headers)

  matcher <- pactr::Matcher$new()
  body <- list("message" = matcher$somethingLike("Hello, Bob"))
  response$setBody(body)

```

In this example, we are using matchers. This allows us to add flexible rules when matching the expectation with the actual value. In the example, you will see a "type" is used to validate that the response is valid.



Matcher | Explanation | Parameters | Example
---|---|---|---
term | Match a value against a regex pattern. | Value, Regex Pattern | $matcher->term('Hello, Bob', '(Hello, )[A-Za-z]')
regex | Alias to term matcher. | Value, Regex Pattern | $matcher->regex('Hello, Bob', '(Hello, )[A-Za-z]')
like | Match a value against its data type. | Value | $matcher->like(12)
somethingLike | Alias to like matcher. | Value | $matcher->somethingLike(12)


### Build the Interaction

Now that we have the request and response, we need to build the interaction and ship it over to the mock server.

```R
  # these are mostly duplicates that you may be able to find a way to streamline
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
  builder$willRespondWith(response) # This has to be last. This is what makes an API request to the Mock Server to set the interaction.

```

### Make the Request
Pick your HTTP client lib.  In short ou are hitting the Pact Server
```R

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

status <- sendRequest(config, request)
expect_equal(as.integer(status), 200)

```

### Verify Interactions

Verify that all interactions took place that were registered.

This typically should be in each test, that way the test that failed to verify is marked correctly.

```R
  result <- builder$verify()
  expect_equal(result, TRUE)
```

Make some assertions to verify that the data you would expect given the response configured is correct.

If you want to write the pact file to disk, leverage finalize()

```R
# write the pact for the testProviderEnd2End
builder$finalize()
```

## Basic Provider Usage

All of the following code will be used exclusively for Providers. This will run the Pacts against the real Provider and either verify or fail validation on the Pact Broker.

##### Create Unit Test

Create a single unit test function. This will test a single consumer of the service.

##### Start API

Get an instance of the API up and running. [Click here](#starting-api-asynchronously) for some tips.

If you need to set up the state of your API before making each request please see [Set Up Provider State](#set-up-provider-state).

### Provider Verification

There are three ways to verify Pact files. See the examples below.
- Verify from a Pact Broker
- Verify All from Pact Broker
- Verify Files by Path

##### Verify Files by Path

This will grab the Pact file from a directory against the stood up API.

```R
  config <- pactr::PactVerifierConfig$new();
  config$setProviderName("someProvider");
  config$setProviderBaseUrl("http://localhost:8000");
  config$setProviderVersion("1.0.0");

  base_dir = paste0(getwd(), "/../../")
  pact_install_dir = paste0(base_dir, "../pact-bin");
  verifier <- pactr::PactVerifier$new(config, install_pact_dir=pact_install_dir);
process_x_args = list("stdout" = "|",
                        "stderr" = paste0(base_dir,"../example/logs/provider_validation_stderr.log"))

  # needs to be run after consumer
  exit_code <- verifier$verifyFiles(c(paste0(base_dir,"../output/someconsumer-someprovider.json")), process_x_args)
  

// If Ruby failed, it will return an invalid error code
 expect_equal(as.integer(exit_code), 0)
```


## Tips

### Set Up Provider State

The PACT verifier is a wrapper of the [Ruby Standalone Verifier](https://github.com/pact-foundation/pact-provider-verifier).
See [API with Provider States](https://github.com/pact-foundation/pact-provider-verifier#api-with-provider-states) for more information on how this works.
Since most R rest APIs are stateless, this required some thought.

Here are some options:
1. Write the posted state to a file and use a factory to decide which mock repository class to use based on the state.
2. Set up your database to meet the expectations of the request. At the start of each request, you should first reset the database to its original state.

No matter which direction you go, you will have to modify something outside of the R process because each request to your server will be stateless and independent.

### Starting Api Asynchronously
Similar to spining up the Mock Service for a consumer, you need to actually stand up an instance of the API to test.  This can be a little goofy if the API is really large or stateful.  It can definitely be done.

PactR provides a wrapper for ProcessX that you can use.  Below is an example of running Plumber

```R
plumber_server_runner <- pactr::ProcessRunner$new(
    "/usr/bin/Rscript",
    c("--vanilla", "../example/run_server.R"),
    list("stdout" = "../example/logs/provider_service_stdout.log", 
         "stderr" = "../example/logs/provider_service_stderr.log")
  )
plumber_server_process <- plumber_server_runner$runNonBlocking()
```

Either from `plumber_server_process` or `plumber_server_runner`, you should br able to kill the process. 
