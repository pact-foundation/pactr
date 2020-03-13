######################################################################
#' Http Service that interacts with the Ruby Standalone Mock Server
#'
#' @importFrom R6 R6Class 
#' @export
MockServerHttpService <- R6Class(
  "MockServerHttpService",
  public = list(
    initialize = function(config) {
      utility <- PactUtility$new()
      utility$EnforceR6ClassType(config, "MockServerConfig")
      
      private$config <- config
      
      # todo change to accept authorization
      private$headers <- c("X-Pact-Mock-Service" = "true",
                           "Content-Type" = "application/json")
    },
    healthCheck = function() {
      h = basicHeaderGatherer()
      
      res <-
        getURI(
          url = private$config$getUri(),
          .opts = list(httpheader = private$headers,
                       verbose = TRUE),
          headerfunction = h$update
        )
      
      statusCode <- h$value()["status"]
      
      
      if (statusCode == "200") {
        return(TRUE)
      }
      
      return(FALSE)
    },
    deleteAllInteractions = function() {
      curl <- getCurlHandle()
      curlSetOpt(.opts = list(httpheader = private$headers,
                              verbose = TRUE),
                 curl = curl)
      
      res <-
        httpDELETE(url = paste0(private$config$getUri(), "/interactions"),
                   curl = curl)
      return(res[1])
    },
    registerInteraction = function(interaction) {
      interactionStr <-
        jsonlite::toJSON(
          interaction$jsonReady(),
          auto_unbox = TRUE,
          simplifyVector = FALSE,
          simplifyDataFrame = FALSE,
          simplifyMatrix = FALSE
        )
      h = basicTextGatherer()
      result <-
        curlPerform(
          url = paste0(private$config$getUri(), "/interactions"),
          httpheader = private$headers,
          postfields = interactionStr,
          writefunction = h$update,
          verbose = TRUE
        )
      
      return(h$value())
    },
    verifyInteractions = function() {
      hG = basicHeaderGatherer()
      tG = basicTextGatherer()
      
      url <-
        paste0(private$config$getUri(), "/interactions/verification")
      res <-
        getURI(
          url = url,
          .opts = list(httpheader = private$headers,
                       verbose = TRUE),
          headerfunction = hG$update,
          write = tG$update
        )
      
      # @todo add error logs about the verification results
      
      statusCode <- hG$value()["status"]
      
      
      if (statusCode == "200") {
        return(TRUE)
      }
      
      return(FALSE)
    },
    getPactJson = function() {
      h = basicTextGatherer()
      result <-
        curlPerform(
          url = paste0(private$config$getUri(), "/pact"),
          httpheader = private$headers,
          postfields = "",
          writefunction = h$update,
          verbose = TRUE
        )
      
      return(h$value())
    },
    performPactConsumerHttpRequest = function(baseUrl, consumerRequest) {
      utility <- PactUtility$new()
      utility$EnforceR6ClassType(consumerRequest, "ConsumerRequest")
      
      if (tolower(consumerRequest$getMethod()) != tolower("GET")) {
        stop(
          sprintf(
            "Only supporting GET requests at this point: %s",
            consumerRequest$getMethod()
          ),
          call. = FALSE
        )
      }
      
      url <-
        paste0(baseUrl, consumerRequest$getPath())
      
      if (!is.null(consumerRequest$getQuery())) {
        url <- paste0(url, "?", consumerRequest$getQuery())
      }
      
      h = basicHeaderGatherer()
      res <- getURI(
        url,
        .opts = list(httpheader = consumerRequest$getHeaders(),
                     verbose = TRUE),
        headerfunction = h$update
      )
      
      statusCode <- h$value()["status"]
      
      if (statusCode == "200") {
        return(TRUE)
      }
      
      return(FALSE)
    }
  ),
  private = list(headers = c(),
                 config = NA)
)
