######################################################################
# Create the Consumer Request object
#
# This is used as a DSL representing a request
#' @export
ConsumerRequest <- R6Class("ConsumerRequest",
                          public = list(
                            initialize = function(thePath) {
                              self$setPath(thePath)
                            },
                            getMethod = function() {
                              private$method
                            },
                            setMethod = function(val) {
                              private$method = val
                              invisible(self)
                            },
                            getPath = function() {
                              private$path
                            },
                            setPath = function(val) {
                              private$path = val
                              invisible(self)
                            },
                            getQuery = function() {
                              private$Query
                            },
                            setQuery = function(val) {
                              private$query = val
                              invisible(self)
                            },
                            getHeaders = function() {
                              private$header
                            },
                            setHeaders = function(val) {
                              private$headers = val
                              invisible(self)
                            },
                            getBody = function() {
                              private$body
                            },
                            setBody = function(val) {
                              private$body = val
                              invisible(self)
                            },
                            jsonReady = function() {
                              jsonList <- list(
                                method = private$method,
                                path = private$path,
                                headers = private$headers,
                                body = private$body
                              )
                                                      
                              return (jsonList)
                            }
                          ),
                          private = list(
                            method = character(0),
                            path = character(0),
                            query = character(0),
                            headers = c(),
                            body = character(0)
                          )
)
