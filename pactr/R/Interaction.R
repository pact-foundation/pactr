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
                              private$request = val
                              invisible(self)
                            },
                            getResponse = function() {
                              private$response
                            },
                            setResponse = function(val) {
                              private$response = val
                              invisible(self)
                            }
                          ),
                          private = list(
                            description = character(0),
                            providerState = character(0), #should this be a different object type?
                            request = NA,
                            response = NA
                          )
)
