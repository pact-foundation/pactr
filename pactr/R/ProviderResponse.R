######################################################################
# Create the Provider Response object
#
# This is used as a DSL representing a response
#' @export
ProviderResponse <- R6Class("ProviderResponse",
                          public = list(
                            initialize = function() {
                            },
                            getStatus = function() {
                              private$status
                            },
                            setStatus = function(val) {
                              private$status = val
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
                            }
                          ),
                          private = list(
                            status = character(0),
                            headers = c(),
                            body = character(0)
                          )
)
