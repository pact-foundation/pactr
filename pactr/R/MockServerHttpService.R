######################################################################
# Http Service that interacts with the Ruby Standalone Mock Server
#
#' @export
MockServerHttpService <- R6Class("MockServerHttpService",
                              public = list(
                                initialize = function(config) {
                                  utility <- PactUtility$new()
                                  utility$EnforceR6ClassType(config, "MockServerConfig")

                                  private$config <- config

                                  # todo change to accept authorization
                                  private$headers <- c(
                                    "X-Pact-Mock-Service" = "true",
                                    "Content-Type" = "application/json"
                                  )
                                },
                                healthCheck = function() {
                                  curl <- getCurlHandle()
                                  curlSetOpt(.opts = list(
                                    httpheader = private$headers,
                                    verbose = TRUE),
                                    curl = curl
                                  )

                                  res <- getURLContent(url=private$config$getUri(), curl=curl)
                                  res <- gsub("[\r\n]", "", res[1])

                                  if (res == "Mock service running") {
                                    return(TRUE)
                                  }

                                  return(FALSE)
                                },
                                deleteAllInteractions = function() {
                                  curl <- getCurlHandle()
                                  curlSetOpt(.opts = list(
                                      httpheader = private$headers,
                                      verbose = TRUE),
                                    curl = curl
                                  )

                                  res <- httpDELETE(url = paste0(private$config$getUri(),"/interactions"), curl=curl)
                                  return(res[1])
                                },
                                registerInteraction = function(interaction) {

                                  h = basicTextGatherer()
                                  result <- curlPerform(url = paste0(private$config$getUri(),"/interactions"),
                                                        httpheader=private$headers,
                                                        postfields=interaction,
                                                        writefunction = h$update,
                                                        verbose = TRUE
                                  )

                                  return(h$value())
                                },
                                verifyInteractions = function() {
                                  return(TRUE)
                                },
                                getPactJson = function() {
                                  return(TRUE)
                                }
                              ),
                              private = list(
                                headers = c(),
                                config = NA
                              )
)
