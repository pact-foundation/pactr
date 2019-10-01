######################################################################
# Wrapper for all the Ruby Pact Scripts to call
#
#' @export
PactScripts <- R6Class("PactScripts",
                       public = list(
                            mockService = NA,
                            stubService = NA,
                            providerVerifier = NA,
                            pactMessage = NA,
                             initialize = function(mockService, stubService, providerVerifier, pactMessage) {
                                self$mockService      <- mockService
                                self$stubService      <- stubService
                                self$providerVerifier <- providerVerifier
                                self$pactMessage      <- pactMessage
                            }
                       ),
                       private = list()
)
