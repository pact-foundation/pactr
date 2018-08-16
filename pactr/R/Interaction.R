######################################################################
# Create the Pact Interaction object
#
# This is used as a DSL representing an Interaction
#' @export
Interaction <- R6Class("Interaction",
                          public = list(
                            initialize = function() {
                            },
                            getDescription = function() {
                              private$description
                            },
                            setDescription = function(val) {
                              private$description = val
                              invisible(self)
                            },
                            getProviderState = function() {
                              private$providerState
                            },
                            setProviderState = function(val) {
                              private$providerState = val
                              invisible(self)
                            },
                            getRequest = function() {
                              private$request
                            },
                            setRequest = function(val) {
                              utility <- PactUtility$new()
                              utility$EnforceR6ClassType(val, "ConsumerRequest")
                              
                              private$request = val
                              invisible(self)
                            },
                            getResponse = function() {
                              private$response
                            },
                            setResponse = function(val) {
                              utility <- PactUtility$new()
                              utility$EnforceR6ClassType(val, "ProviderResponse")
                              
                              private$response = val
                              invisible(self)
                            },
                            jsonReady = function() {
                              jsonList <- list(
                                description = private$description,
                                providerState = private$providerState,
                                request = private$request$jsonReady(),
                                response = private$response$jsonReady()
                              )
                              
                              return (jsonList)
                            },
                            toJSON = function() {
                              json <- jsonlite::toJSON(self$jsonReady(), auto_unbox = TRUE)
                              return (json)
                            }
                          ),
                          private = list(
                            description = character(0),
                            providerState = character(0),
                            request = NA,
                            response = NA
                          )
)
