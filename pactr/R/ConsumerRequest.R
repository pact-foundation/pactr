######################################################################
# Create the Consumer Request object
#
# This is used as a DSL representing a request
#' @export
ConsumerRequest <- R6Class("ConsumerRequest",
                          public = list(
                            initialize = function(path="/", method="GET") {
                              self$setPath(path)
                              self$setMethod(method)
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
                              jsonList <- list()
                              jsonList$method <- private$method
                              
                              if (!is.null(private$headers)) {
                                jsonList$headers <- private$headers
                              }
                              
                              if (!is.null(private$path)) {
                                jsonList$path <- private$path
                              }
                              
                              if (!is.null(private$body)) {
                                jsonList$body <- private$body
                              }
                              
                              if (!is.null(private$query)) {
                                jsonList$query <- private$query
                              }
                              
                              return (jsonList)
                            }
                          ),
                          private = list(
                            method = NULL,
                            path = NULL,
                            query = NULL,
                            headers = NULL,
                            body = NULL
                          )
)
